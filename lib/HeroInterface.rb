require_relative "SimcConfig"
require_relative "JSONParser"
require_relative "Logging"
require_relative "ProfileHelper"
require "git"

module HeroInterface
  @updatedHD = false

  TargetErrorDiffFactor = 2

  # Check and update HeroDamage repo. Returns false if no repo found or exceptions occur.
  def self.PullLatest
    return true if @updatedHD
    begin
      Logging.LogScriptInfo "Updating HD repo at #{SimcConfig["HeroDamagePath"]}..."
      g = Git.open(SimcConfig["HeroDamagePath"])
      g.pull
      @updatedHD = true
    rescue => err
      Logging.LogScriptError "Error updating HeroDamage repository. Make sure the path is set and it is a git repository."
      Logging.LogScriptError err
      return false
    end
    return true
  end

  # Azerite stacks will be converted into Combinator-XA_*. nil will just be Combinator_*.
  def self.GetRawCombinationData(azeriteStacks, fightstyle, profile)
    # First look if there is a local report, then check HeroDamage repository.
    azSuffix = azeriteStacks ? "-#{azeriteStacks}A" : ""
    combinationsFile = "Combinator#{azSuffix}_#{fightstyle}_#{profile}.json"
    localPath = "#{SimcConfig["ReportsFolder"]}/#{combinationsFile}"
    hdPath = "#{SimcConfig["HeroDamagePath"]}/#{SimcConfig["HeroDamageReportsFolder"]}/#{combinationsFile}"
    if File.exist?(localPath)
      Logging.LogScriptInfo "Reading combinations file #{localPath}..."
      data = JSONParser.ReadFile(localPath)
    elsif PullLatest() && File.exist?(hdPath)
      Logging.LogScriptInfo "Reading combinations file #{hdPath}..."
      data = JSONParser.ReadFile(hdPath)
    else
      Logging.LogScriptWarning "File #{combinationsFile} not found for combinations."
      return nil
    end
    return data
  end

  # Get best talent builds for the Azerite sim at given stacks per power using Combinations results.
  def self.GetAzeriteCombinations(fightstyle, profile, defaultTalents)
    return {} unless SimcConfig["CombinationBasedCharts"]
    unless SimcConfig["HeroOutput"]
      Logging.LogScriptError "HeroOutput option off with CombinationBasedCharts on! This may cause problems!"
    end

    profile = ProfileHelper.NormalizeProfileName(profile)
    data = GetRawCombinationData(3, fightstyle, profile)
    genericData = GetRawCombinationData(0, fightstyle, profile)

    if !data || !genericData
      Logging.LogScriptWarning "Skipping combinator based profileset generation for #{profile}. This may or may not be intended and should be double checked."
      return {}
    end

    # Create an array of azeritePowerName from genericCombinatorPowers to exclude them from the results
    genericPowers = []
    powerList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/AzeritePower.json")
    powerSettings = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/AzeriteOptions.json")
    powerList.each do |power|
      genericPowers.push(power["spellName"]) if powerSettings["genericCombinatorPowers"].include?(power["powerId"])
    end

    # Combinations results array mapping:
    # result: 0-rank, 1-talents, 2-set, 3-powerName, 4-dps

    # Filter the combinations results to only keep non-generic powers
    filteredResults = data["results"].select { |result| !genericPowers.include?(result[3]) }

    # Create a map of azeritePowerName => DPS using default talent build
    defaultResults = filteredResults.select { |result| result[1] == defaultTalents }
    defaultTalentsFound = false
    if defaultResults.empty?
      Logging.LogScriptWarning "Default talents #{defaultTalents} were not found for #{profile}, make sure the default build is included to make best usage of this feature."
    else
      defaultTalentsFound = true
      defaultMatchedData = {}
      defaultResults.each do |result|
        unless defaultMatchedData.has_key?(result[3])
          defaultMatchedData[result[3]] = result[4]
        end
      end
    end

    # Set up threshold for comparison based on target error
    targetError = [data["metas"]["targetError"], genericData["metas"]["targetError"]].max
    minimalDifferenceFromDefaults = targetError * TargetErrorDiffFactor

    # Create a map of azeritePowerName => talent build using best DPS
    matchedData = {}
    filteredResults.each do |result|
      # The results are pre-sorted in DESC order, so if we have an existing entry then we already got the best candidate
      unless matchedData.has_key?(result[3])
        # Check the result against default talents
        if defaultTalentsFound
          # If the dps is not higher than the minimalDifferenceFromDefaults, uses default talents instead.
          defaultDPS = defaultMatchedData[result[3]]
          resultDPS = result[4]
          difference = 100 * resultDPS.to_f / defaultDPS.to_f - 100
          if difference > minimalDifferenceFromDefaults
            matchedData[result[3]] = result[1]
            Logging.LogScriptInfo "#{result[3]}: #{result[1]} is better than #{defaultTalents} by #{difference.round(2)}% (#{resultDPS} vs #{defaultDPS})."
          else
            matchedData[result[3]] = defaultTalents
          end
        else
          # Fallback to the result in case the default talents were not present in the combinations
          matchedData[result[3]] = result[1]
          Logging.LogScriptInfo "#{result[3]}: #{result[1]} will be used as fallback, no defaultTalents found."
        end
      end
    end

    # Find the best performing talents build for generics (i.e. no specific power)
    if defaultTalentsFound
      defaultGenericResult = genericData["results"].select { |result| result[1] == defaultTalents }.first
      topGenericResult = genericData["results"].first
      defaultGenericDPS = defaultGenericResult[4]
      topGenericDPS = topGenericResult[4]
      genericDifference = 100 * topGenericDPS.to_f / defaultGenericDPS.to_f - 100
      if genericDifference > minimalDifferenceFromDefaults
        matchedData["Generic"] = topGenericResult[1]
        Logging.LogScriptInfo "Generic: #{topGenericResult[1]} is better than #{defaultTalents} by #{genericDifference.round(2)}% (#{topGenericDPS} vs #{defaultGenericDPS})."
      else
        matchedData["Generic"] = defaultTalents
      end
    end

    return matchedData
  end

  # Get best talent build overrides (if better) based on Combinations results.
  def self.GetBestCombinationOverrides(fightstyle, profile, defaultTalents)
    return {} unless SimcConfig["CombinationBasedCharts"]
    unless SimcConfig["HeroOutput"]
      Logging.LogScriptError "HeroOutput option off with CombinationBasedCharts on! This may cause problems!"
    end

    profile = ProfileHelper.NormalizeProfileName(profile)
    genericData = GetRawCombinationData(nil, fightstyle, profile)

    if !genericData
      Logging.LogScriptWarning "Skipping combinator based profileset generation for #{profile}. This may or may not be intended and should be double checked."
      return {}
    end

    # Map of override sets by options name (part including and after --)
    # This can easily extended if we want to support multiple sets.
    overrideSets = {}

    # Set up threshold for comparison based on target error
    targetError = genericData["metas"]["targetError"]
    minimalDifferenceFromDefaults = targetError * TargetErrorDiffFactor

    # Combinations results array mapping:
    # result: 0-rank, 1-talents, 2-set, 3-powerName, 4-dps

    # Get the best combination without azerite (if better) and create an override set for it
    best = genericData["results"].first
    default = genericData["results"].find { |x| x[1] == defaultTalents }
    if best && default && best[1] != default[1]
      difference = 100 * best[4].to_f / default[4].to_f - 100
      if difference > minimalDifferenceFromDefaults
        Logging.LogScriptInfo "Simple: Talent build #{best[1]} beats #{default[1]} by #{difference.round(2)}% (#{best[4]} vs #{default[4]})."
        overrideSets["talents:#{best[1]}"] = ["talents=#{best[1]}"]
      end
    elsif !default
      Logging.LogScriptWarning "Default talents #{defaultTalents} were not found for #{profile}, make sure the default build is included to make best usage of this feature."
    end
    return overrideSets
  end
end
