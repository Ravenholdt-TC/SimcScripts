require 'rubygems'
require 'bundler/setup'
require_relative 'SimcConfig'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/SimcHelper'

template = Interactive.SelectTemplate('RelicSimulation/RelicSimulation')
fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')
logFile = "#{SimcConfig::LogsFolder}/RelicSimulation_#{fightstyle}_#{template}"
csvFile = "#{SimcConfig::ReportsFolder}/RelicSimulation_#{fightstyle}_#{template}.csv"
metaFile = "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_#{fightstyle}_#{template}.json"
params = [
  "#{SimcConfig::ConfigFolder}/SimcRelicConfig.simc",
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  "#{SimcConfig::ProfilesFolder}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig::ProfilesFolder}/RelicSimulation/RelicSimulation_#{template}.simc"
]
SimcHelper.RunSimulation(params)

# Extract metadata
puts "Extract metadata from #{logFile}.json to #{metaFile}..."
JSONParser.ExtractMetadata("#{logFile}.json", metaFile)

# Process results
sims = {}
templateDPS = 0
puts "Converting #{logFile}.json to #{csvFile}..."
results = JSONParser.GetAllDPSResults("#{logFile}.json")
results.each do |name, dps|
  if data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
  elsif name == 'Template'
    templateDPS = dps
  end
end

# For interpolation to generate graphs that look more linear
WeaponItemLevelName = 'WeaponItemLevel'
WeaponItemLevelSteps = 3

# Interpolate between Weapon Item Level Steps
if sims[WeaponItemLevelName]
  sims[WeaponItemLevelName].sort.each do |amount, dps|
    if amount == WeaponItemLevelSteps
      prevStepDPS = templateDPS
    elsif amount % WeaponItemLevelSteps == 0
      prevStepDPS = sims[WeaponItemLevelName][amount - WeaponItemLevelSteps]
    else
      # Not a step value, delete from storage
      sims[WeaponItemLevelName].delete(amount)
      next
    end
    # Write interpolated values
    range_inc = (dps - prevStepDPS) / WeaponItemLevelSteps
    (1..(WeaponItemLevelSteps) - 1).each do |i|
      sims[WeaponItemLevelName].merge!((amount - WeaponItemLevelSteps + i) => (prevStepDPS + i * range_inc))
    end
  end
end

# Get max number of results (have to fill others for Google Charts to work)
max_columns = 1
sims.each do |name, values|
  max_columns = values.length if values.length > max_columns
end

# Write to CSV
File.open(csvFile, 'w') do |csv|
  sims.each do |name, values|
    csv.write name
    values.sort.each do |amount, dps|
      dps_inc = dps - templateDPS
      csv.write ",#{dps_inc},\"#{amount}\""
    end
    ((values.length + 1)..max_columns).each do |i|
      csv.write ",0,\"\""
    end
    csv.write "\n"
  end
end

puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
