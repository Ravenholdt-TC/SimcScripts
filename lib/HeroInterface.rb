require_relative "SimcConfig"
require_relative "JSONParser"
require_relative "Logging"
require_relative "ProfileHelper"
require "git"

module HeroInterface
  @updatedHD = false

  TargetErrorDiffFactor = 3

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
  def self.GetRawCombinationData(combinatorStyle, fightstyle, profile)
    # First look if there is a local report, then check HeroDamage repository.
    csSuffix = combinatorStyle ? "-#{combinatorStyle}" : ""
    combinationsFile = "Combinator#{csSuffix}_#{fightstyle}_#{profile}.json"
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
    # result: 0-rank, 1-talents, 2-gear, 3-dps

    # Get the best combination without azerite (if better) and create an override set for it
    best = genericData["results"].first
    default = genericData["results"].find { |x| ProfileHelper.TalentsEqual?(x[1], defaultTalents) }
    if best && default && best[1] != default[1]
      difference = 100 * best[3].to_f / default[3].to_f - 100
      if difference > minimalDifferenceFromDefaults
        Logging.LogScriptInfo "Simple: Talent build #{best[1]} beats #{default[1]} by #{difference.round(2)}% (#{best[3]} vs #{default[3]})."
        overrideSets["talents:#{best[1]}"] = ["talents=#{best[1]}"]
      end
    elsif !default
      Logging.LogScriptWarning "Default talents #{defaultTalents} were not found for #{profile}, make sure the default build is included to make best usage of this feature."
    end
    return overrideSets
  end
end
