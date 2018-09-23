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

  # Get best talent builds for the Azerite sim at given stacks per power.
  # First looks if there is a local report, then checks HeroDamage repo.
  def self.GetAzeriteCombinations(stacks, fightstyle, profile)
    return nil unless SimcConfig['CombinationBasedAzeriteCharts']
    unless SimcConfig['HeroOutput']
      Logging.LogScriptError 'HeroOutput option off with CombinationBasedAzeriteCharts on! This may cause problems!'
    end

    simulationFilename = ProfileHelper.NormalizeProfileName(profile)

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

    matchedData = {}
    # Create a map of powername => talent build for first result for each power.
    data['results'].each do |result|
      # result, 0-rank, 1-talents, 2-set, 3-power, 4-dps
      unless matchedData.has_key?(result[3])
        matchedData[result[3]] = result[1]
      end
    end
    return matchedData
  end
end
