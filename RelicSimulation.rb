require 'rubygems'
require 'bundler/setup'
require_relative 'lib/CrucibleWeights'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

classfolder = Interactive.SelectSubfolder('RelicSimulation')
template = Interactive.SelectTemplate("RelicSimulation/#{classfolder}/RelicSimulation")
fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')
logFile = "#{SimcConfig['LogsFolder']}/RelicSimulation_#{fightstyle}_#{template}"
csvFile = "#{SimcConfig['ReportsFolder']}/RelicSimulation_#{fightstyle}_#{template}.csv"
metaFile = "#{SimcConfig['ReportsFolder']}/meta/RelicSimulation_#{fightstyle}_#{template}.json"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcRelicConfig.simc",
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/RelicSimulation/#{classfolder}/RelicSimulation_#{template}.simc"
]
SimcHelper.RunSimulation(params)

# Read JSON Output
results = JSONResults.new("#{logFile}.json")

# Process results
sims = {}
templateDPS = 0
puts "Converting #{logFile}.json to #{csvFile}..."
results.getAllDPSResults().each do |name, dps|
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

# Get string for crucible weight addon and add it to metadata
addToMeta = {}
json = results.getRawJSON()
begin
  simcSpecString = json['sim']['players'].first['specialization']
  cruweight = CrucibleWeights.GetCrucibleWeightString(simcSpecString, sims, templateDPS)
  addToMeta['crucibleweight'] = cruweight if cruweight
rescue KeyError => exception
  puts "ERROR: Spec not found in JSON output. Not generating crucible weight string."
end

# Save metadata
puts "Extract metadata from #{logFile}.json to #{metaFile}..."
results.extractMetadata(metaFile, addToMeta)

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
