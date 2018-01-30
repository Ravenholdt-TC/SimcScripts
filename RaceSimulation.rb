require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/ReportWriter'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

RaceMap = {
  'Night Elf' => 'night_elf',
  'Blood Elf' => 'blood_elf',
  'Dwarf' => 'dwarf',
  'Gnome' => 'gnome',
  'Goblin' => 'goblin',
  'Human' => 'human',
  'Orc' => 'orc',
  'Pandaren' => 'pandaren',
  'Troll' => 'troll',
  'Undead' => 'undead',
  'Worgen' => 'worgen',
  'Tauren' => 'tauren',
  'Draenei' => 'draenei'
  ###### SOON
  #'Void Elf' => 'voidelf',
  #'Highmountain Tauren' => 'highmountaintauren',
  #'Lightforged Draenei' => 'lightforgeddraenei',
  #'Nightborne' => 'nightborne'
}

Logging.Initialize("RaceSimulation")

classfolder = Interactive.SelectSubfolder('Templates')
template = Interactive.SelectTemplate("Templates/#{classfolder}/")
fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')

# Log all interactively set settings
puts
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Profile: #{template}"
Logging.LogScriptInfo "-- Fightstyle: #{fightstyle}"
puts

simcInput = []
Logging.LogScriptInfo "Generating profilesets..."
simcInput.push 'name="Template"'
simcInput.push 'race=none'
simcInput.push ''
RaceMap.each do |name, raceString|
  simcInput.push "profileset.\"#{name}\"+=race=#{raceString}"
end

logFile = "#{SimcConfig['LogsFolder']}/RaceSimulation_#{fightstyle}_#{template}"
reportFile = "#{SimcConfig['ReportsFolder']}/RaceSimulation_#{fightstyle}_#{template}"
metaFile = "#{SimcConfig['ReportsFolder']}/meta/RaceSimulation_#{fightstyle}_#{template}.json"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcRaceConfig.simc",
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/Templates/#{classfolder}/#{template}.simc",
  simcInput
]
SimcHelper.RunSimulation(params, "#{SimcConfig['GeneratedFolder']}/RaceSimulation_#{fightstyle}_#{template}.simc")

# Read JSON Output
results = JSONResults.new("#{logFile}.json")

# Extract metadata
Logging.LogScriptInfo "Extract metadata from #{logFile}.json to #{metaFile}..."
results.extractMetadata(metaFile)

# Write report
Logging.LogScriptInfo "Processing data and writing report to #{reportFile}..."
report = [ ]
sims = results.getAllDPSResults()
templateDPS = sims['Template'] or 0
sims.delete('Template')
sims.each do |name, value|
  actor = [name, value - templateDPS]
  report.push(actor)
end
# Write into the report file
ReportWriter.WriteArrayReport(reportFile, report)

Logging.LogScriptInfo 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
