require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/ReportWriter'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

Logging.Initialize("TrinketSimulation")

classfolder = Interactive.SelectSubfolder('Templates')
template = Interactive.SelectTemplate("Templates/#{classfolder}/")
trinketListProfiles = Interactive.SelectTemplateMulti('TrinketLists/')
fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')

# Log all interactively set settings
puts
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Profile: #{template}"
Logging.LogScriptInfo "-- Trinket List: #{trinketListProfiles}"
Logging.LogScriptInfo "-- Fightstyle: #{fightstyle}"
puts

simcInput = []
Logging.LogScriptInfo "Generating profilesets..."
simcInput.push 'name="Template"'
simcInput.push 'trinket1=empty'
simcInput.push 'trinket2=empty'
simcInput.push ''
trinketListProfiles.each do |trinketListProfile|
  trinketList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/TrinketLists/#{trinketListProfile}.json")
  trinketList['trinkets'].each do |trinket|
    bonusIdString = trinket['bonusIds'].empty? ? '' : ',bonus_id=' + trinket['bonusIds'].join('/')
    trinket['itemLevels'].each do |ilvl|
      simcInput.push "profileset.\"#{trinket['name']}_#{ilvl}\"+=trinket1=,id=#{trinket['itemId']},ilevel=#{ilvl}#{bonusIdString}"
      trinket['additionalInput'].each do |input|
        simcInput.push "profileset.\"#{trinket['name']}_#{ilvl}\"+=#{input}"
      end
    end
    simcInput.push ''
  end
end

logFile = "#{SimcConfig['LogsFolder']}/TrinketSimulation_#{fightstyle}_#{template}"
reportFile = "#{SimcConfig['ReportsFolder']}/TrinketSimulation_#{fightstyle}_#{template}"
metaFile = "#{SimcConfig['ReportsFolder']}/meta/TrinketSimulation_#{fightstyle}_#{template}.json"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcTrinketConfig.simc",
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/Templates/#{classfolder}/#{template}.simc",
  simcInput
]
SimcHelper.RunSimulation(params, "#{SimcConfig['GeneratedFolder']}/TrinketSimulation_#{fightstyle}_#{template}.simc")

# Read JSON Output
results = JSONResults.new("#{logFile}.json")

# Extract metadata
Logging.LogScriptInfo "Extract metadata from #{logFile}.json to #{metaFile}..."
results.extractMetadata(metaFile)

Logging.LogScriptInfo "Processing data and writing report to #{reportFile}..."
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

# Write report
report = [ ]
# Header
header = [ "Trinket" ]
iLevelList.each do |ilvl|
  header.push(ilvl.to_s)
end
report.push(header)
# Trinkets
sims.each do |name, values|
  actor = [ ]
  actor.push(name)
  iLevelList.each do |ilvl|
    if values[ilvl]
      actor.push(values[ilvl] - templateDPS)
    else
      actor.push(0)
    end
  end
  report.push(actor)
end
# Write into the report file
ReportWriter.WriteArrayReport(reportFile, report)

Logging.LogScriptInfo 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
