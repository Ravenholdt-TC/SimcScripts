require_relative 'SimcConfig'
require_relative 'JSONParser'
require_relative 'Logging'
require_relative 'ProfileHelper'
require 'git'

module HeroInterface
  @@updatedHD = false

  # Check and update HeroDamage repo. Returns false if no repo found or exceptions occur.
  def self.PullLatest
    return true if @@updatedHD
    begin
      Logging.LogScriptInfo "Updating HD repo at #{SimcConfig['HeroDamagePath']}..."
      g = Git.open(SimcConfig['HeroDamagePath'])
      g.pull
      @@updatedHD = true
    rescue => err
      Logging.LogScriptWarn 'Error updating HeroDamage repository. Make sure the path is set and it is a git repository.'
      Logging.LogScriptWarn err
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

    simulationFilename = ProfileHelper.NormalizeProfileName(profile)

    # First look if there is a local report then checks HeroDamage repository.
    combinationsFile = "Combinator-#{stacks}A_#{fightstyle}_#{profile}.json"
    localPath = "#{SimcConfig['ReportsFolder']}/#{combinationsFile}"
    hdPath = "#{SimcConfig['HeroDamagePath']}/#{SimcConfig['HeroDamageReportsFolder']}/#{combinationsFile}"
    if File.exist?(localPath)
      Logging.LogScriptInfo "Reading combinations file #{localPath}..."
      data = JSONParser.ReadFile(localPath)
    elsif PullLatest() && File.exist?(hdPath)
      Logging.LogScriptInfo "Reading combinations file #{hdPath}..."
      data = JSONParser.ReadFile(hdPath)
    else
      Logging.LogScriptFatal "File #{combinationsFile} not found for combinations."
      exit
    end

    # Combinations results array mapping:
    # result: 0-rank, 1-talents, 2-set, 3-power, 4-dps

    targetError = 0.4 # TODO: Read from SimcCombinatorConfig.simc ?
    minimalDifferenceFromDefaults = targetError * 3

    # Create a map of azeritePowerName => DPS using default talent build
    defaultResults = data['results'].select { |result| result[1] == defaultTalents}
    defaultMatchedData = {}
    defaultResults.each do |result|
      unless defaultMatchedData.has_key?(result[3])
        defaultMatchedData[result[3]] = result[4]
      end
    end

    # Create a map of azeritePowerName => talent build using best DPS
    matchedData = {}
    data['results'].each do |result|
      # The results are already sorted, so if we already have the key then we already got the best candidate
      unless matchedData.has_key?(result[3])
        # If the dps is not higher than the minimalDifferenceFromDefaults, uses default talents instead.
        defaultDPS = defaultMatchedData[result[3]]
        resultDPS = result[4]
        difference = 100 * resultDPS / defaultDPS - 100
        if difference > minimalDifferenceFromDefaults
          matchedData[result[3]] = result[1]
        else
          matchedData[result[3]] = defaultTalents
        end
      end
    end
    return matchedData
  end
end
