require_relative '../SimcConfig'
require 'json'

# Used for parsing json2 output from simc
module JSONParser
  # Returns full JSON hash from a file
  def self.ReadFile(file)
    return JSON.parse(File.read(file))
  end

  # Returns DPS for all profiles and profilesets in a JSON report
  def self.GetAllDPSResults(jsonFile)
    results = { }
    json = ReadFile(jsonFile)
    json['sim']['players'].each do |player|
      results[player['name']] = player['collected_data']['dps']['mean']
    end
    json['sim']['profilesets']['results'].each do |player|
      results[player['name']] = player['mean']
    end
    return results
  end
end
