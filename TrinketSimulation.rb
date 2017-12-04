require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

classfolder = Interactive.SelectSubfolder('TrinketSimulation')
template = Interactive.SelectTemplate("TrinketSimulation/#{classfolder}/TrinketSimulation")
trinketListProfile = Interactive.SelectTemplate('TrinketSimulation/TrinketList')
fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')

trinketList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/TrinketSimulation/TrinketList_#{trinketListProfile}.json")
simcFile = "#{SimcConfig['GeneratedFolder']}/TrinketSimulation_#{fightstyle}_#{template}.simc"
puts "Writing profilesets to #{simcFile}!"
File.open(simcFile, 'w') do |out|
  out.puts 'name="Template"'
  out.puts 'trinket1=empty'
  out.puts 'trinket2=empty'
  out.puts
  trinketList['trinkets'].each do |trinket|
    bonusIdString = trinket['bonusIds'].empty? ? '' : ',bonus_id=' + trinket['bonusIds'].join('/')
    trinket['itemLevels'].each do |ilvl|
      out.puts "profileset.\"#{trinket['name']}_#{ilvl}\"+=trinket1=,id=#{trinket['itemId']},ilevel=#{ilvl}#{bonusIdString}"
      trinket['additionalInput'].each do |input|
        out.puts "profileset.\"#{trinket['name']}_#{ilvl}\"+=#{input}"
      end
    end
    out.puts
  end
end

puts 'Starting simulations, this may take a while!'
logFile = "#{SimcConfig['LogsFolder']}/TrinketSimulation_#{fightstyle}_#{template}"
csvFile = "#{SimcConfig['ReportsFolder']}/TrinketSimulation_#{fightstyle}_#{template}.csv"
metaFile = "#{SimcConfig['ReportsFolder']}/meta/TrinketSimulation_#{fightstyle}_#{template}.json"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcTrinketConfig.simc",
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/TrinketSimulation/#{classfolder}/TrinketSimulation_#{template}.simc",
  simcFile
]
SimcHelper.RunSimulation(params)

# Read JSON Output
results = JSONResults.new("#{logFile}.json")

# Extract metadata
puts "Extract metadata from #{logFile}.json to #{metaFile}..."
results.extractMetadata(metaFile)

puts "Processing data from #{logFile}.json to #{csvFile}..."
templateDPS = 0
iLevelList = []
sims = {}
results.getAllDPSResults().each do |name, dps|
  if data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
    iLevelList.push(data[2].to_i)
  elsif name == 'Template'
    templateDPS = dps
  end
end
iLevelList.uniq!
iLevelList.sort!

# Write to CSV
File.open(csvFile, 'w') do |csv|
  #CSV header line
  csv.puts "Trinket," + iLevelList.join(',')
  sims.each do |name, values|
    csv.write name
    iLevelList.each do |ilvl|
      if values[ilvl]
        dps_inc = values[ilvl] - templateDPS
        csv.write ",#{dps_inc}"
      else
        csv.write ',0'
      end
    end
    csv.write "\n"
  end
end

puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
