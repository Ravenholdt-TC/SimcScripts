require_relative 'SimcConfig'
require_relative 'JSONParser'
require_relative 'Logging'
require_relative 'ProfileHelper'
require 'git'

module HeroInterface
  @@updatedHD = false

    # Compute minimalDifferenceFromDefaults
  @@targetError = 0.4 # TODO: Read from SimcCombinatorConfig.simc ?
  @@minimalDifferenceFromDefaults = @@targetError * 2

  # Create an array of azeritePowerName from genericCombinatorPowers to exclude them from the results
  @@genericPowers = []
  @@powerList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeritePower.json")
  @@powerSettings = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeriteOptions.json")
  @@powerList.each do |power|
    @@genericPowers.push(power['spellName']) if @@powerSettings['genericCombinatorPowers'].include?(power['powerId'])
  end

  # Check and update HeroDamage repo. Returns false if no repo found or exceptions occur.
  def self.PullLatest
    return true if @@updatedHD
    begin
      Logging.LogScriptInfo "Updating HD repo at #{SimcConfig['HeroDamagePath']}..."
      g = Git.open(SimcConfig['HeroDamagePath'])
      g.pull
      @@updatedHD = true
    rescue => err
      Logging.LogScriptError 'Error updating HeroDamage repository. Make sure the path is set and it is a git repository.'
      Logging.LogScriptError err
      return false
    end
    return true
  end

  # Get best talent builds for the Azerite sim at given stacks per power using Combinations results.
  def self.GetAzeriteCombinations(stacks, fightstyle, defaultTalents, profile)
    return nil unless SimcConfig['CombinationBasedAzeriteCharts']
    unless SimcConfig['HeroOutput']
      Logging.LogScriptError 'HeroOutput option off with CombinationBasedAzeriteCharts on! This may cause problems!'
    end
    unless stacks > 0
      Logging.LogScriptError '0 stack AzeriteCombinations called! This may cause problems since they are always used!'
    end

    simulationFilename = ProfileHelper.NormalizeProfileName(profile)

    # First look if there is a local report then checks HeroDamage repository.
    combinationsFile = "Combinator-#{stacks}A_#{fightstyle}_#{profile}.json"
    combinationsGenericFile = "Combinator-0A_#{fightstyle}_#{profile}.json"
    localPath = "#{SimcConfig['ReportsFolder']}/#{combinationsFile}"
    localGenericPath = "#{SimcConfig['ReportsFolder']}/#{combinationsGenericFile}"
    hdPath = "#{SimcConfig['HeroDamagePath']}/#{SimcConfig['HeroDamageReportsFolder']}/#{combinationsFile}"
    hdGenericPath = "#{SimcConfig['HeroDamagePath']}/#{SimcConfig['HeroDamageReportsFolder']}/#{combinationsGenericFile}"
    if File.exist?(localPath) && File.exist?(localGenericPath)
      Logging.LogScriptInfo "Reading combinations file #{localPath}..."
      data = JSONParser.ReadFile(localPath)
      Logging.LogScriptInfo "Reading combinations file #{localGenericPath}..."
      genericData = JSONParser.ReadFile(localGenericPath)
    elsif PullLatest() && File.exist?(hdPath) && File.exist?(hdGenericPath)
      Logging.LogScriptInfo "Reading combinations file #{hdPath}..."
      data = JSONParser.ReadFile(hdPath)
      Logging.LogScriptInfo "Reading combinations file #{hdGenericPath}..."
      genericData = JSONParser.ReadFile(hdGenericPath)
    else
      Logging.LogScriptFatal "File #{combinationsFile} or #{combinationsGenericFile} not found for combinations."
      exit
    end

    # Combinations results array mapping:
    # result: 0-rank, 1-talents, 2-set, 3-powerName, 4-dps

    # Filter the combinations results to only keep non-generic powers
    filteredResults = data['results'].select { |result| !@@genericPowers.include?(result[3]) }

    # Create a map of azeritePowerName => DPS using default talent build
    defaultTalentsFound = true
    defaultResults = filteredResults.select { |result| result[1] == defaultTalents }
    if defaultResults.empty?
      Logging.LogScriptWarning 'defaultTalents were not found in combinations results, make sure the default build is included in Combinations simulations to make best usage of this feature.'
      defaultTalentsFound = false
      defaultMatchedData = {}
      defaultResults.each do |result|
        unless defaultMatchedData.has_key?(result[3])
          defaultMatchedData[result[3]] = result[4]
        end
      end
    end

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
          difference = 100 * resultDPS / defaultDPS - 100
          if difference > @@minimalDifferenceFromDefaults
            matchedData[result[3]] = result[1]
          else
            matchedData[result[3]] = defaultTalents
          end
        else
          # Fallback to the result in case the default talents were not present in the combinations
          matchedData[result[3]] = result[1]
        end
      end
    end

    # Find the best performing talents build for generics (i.e. no specific power)
    if defaultTalentsFound
      defaultGenericResult = genericData['results'].select { |result| result[1] == defaultTalents }.first
      topGenericResult = genericData['results'].first
      defaultGenericDPS = defaultGenericResult[4]
      topGenericDPS = topGenericResult[4]
      genericDifference = 100 * topGenericDPS / defaultGenericDPS - 100
      if genericDifference > @@minimalDifferenceFromDefaults
        matchedData['Generic'] = topGenericResult[1]
      else
        matchedData['Generic'] = defaultTalents
      end
    end

    return matchedData
  end
end
