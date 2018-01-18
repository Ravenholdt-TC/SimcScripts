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

classfolder = Interactive.SelectSubfolder('TrinketSimulation')
template = Interactive.SelectTemplate("TrinketSimulation/#{classfolder}/TrinketSimulation")
trinketListProfile = Interactive.SelectTemplate('TrinketSimulation/TrinketList')
fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')

# Log all interactively set settings
puts
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Profile: #{template}"
Logging.LogScriptInfo "-- Trinket List: #{trinketListProfile}"
Logging.LogScriptInfo "-- Fightstyle: #{fightstyle}"
puts

trinketList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/TrinketSimulation/TrinketList_#{trinketListProfile}.json")
simcFile = "#{SimcConfig['GeneratedFolder']}/TrinketSimulation_#{fightstyle}_#{template}.simc"
Logging.LogScriptInfo "Writing profilesets to #{simcFile}!"
File.open(simcFile, 'w') do |out|
  out.puts("# --- Trinkets Config ---")
  out.puts(File.read("#{SimcConfig['ConfigFolder']}/SimcTrinketConfig.simc"))
  out.puts
  out.puts("# --- #{fightstyle} Fightstyle ---")
  out.puts(File.read("#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc"))
  out.puts
  out.puts("# --- #{template} ---")
  out.puts(File.read("#{SimcConfig['ProfilesFolder']}/TrinketSimulation/#{classfolder}/TrinketSimulation_#{template}.simc"))
  out.puts
  out.puts("# --- Trinkets ---")
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

Logging.LogScriptInfo 'Starting simulations, this may take a while!'
logFile = "#{SimcConfig['LogsFolder']}/TrinketSimulation_#{fightstyle}_#{template}"
reportFile = "#{SimcConfig['ReportsFolder']}/TrinketSimulation_#{fightstyle}_#{template}"
metaFile = "#{SimcConfig['ReportsFolder']}/meta/TrinketSimulation_#{fightstyle}_#{template}.json"
params = [
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  simcFile
]
SimcHelper.RunSimulation(params)

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
