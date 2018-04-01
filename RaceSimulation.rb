require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/ReportWriter'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

# Map race name and simc string
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
  'Draenei' => 'draenei',
  'Void Elf' => 'void_elf',
  'Highmountain Tauren' => 'highmountain_tauren',
  'Lightforged Draenei' => 'lightforged_draenei',
  'Nightborne' => 'nightborne'
  ###### BfA
  #'Zandalari Troll' => 'zandalari_troll',
  #'Dark Iron Dwarf' => 'dark_iron_dwarf'
}

# Map class folder and race name
ClassMap = {
  'DeathKnight' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Orc', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Goblin'],
  'DemonHunter' => ['Night Elf', 'Blood Elf'],
  'Druid' => ['Night Elf', 'Worgen', 'Tauren', 'Troll', 'Highmountain Tauren'],
  'Hunter' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Lightforged Draenei', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Goblin', 'Highmountain Tauren', 'Nightborne'],
  'Mage' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Lightforged Draenei', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Troll', 'Blood Elf', 'Goblin', 'Nightborne'],
  'Monk' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Highmountain Tauren', 'Nightborne'],
  'Paladin' => ['Human', 'Dwarf', 'Draenei', 'Lightforged Draenei', 'Tauren', 'Blood Elf'],
  'Priest' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Lightforged Draenei', 'Void Elf', 'Pandaren', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Goblin', 'Nightborne'],
  'Rogue' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Worgen', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Troll', 'Blood Elf', 'Goblin', 'Nightborne'],
  'Shaman' => ['Dwarf', 'Draenei', 'Pandaren', 'Orc', 'Tauren', 'Troll', 'Goblin', 'Highmountain Tauren'],
  'Warlock' => ['Human', 'Dwarf', 'Gnome', 'Worgen', 'Void Elf', 'Orc', 'Undead', 'Troll', 'Blood Elf', 'Goblin', 'Nightborne'],
  'Warrior' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Lightforged Draenei', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Goblin', 'Highmountain Tauren', 'Nightborne']
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
  if ClassMap[classfolder].include?(name)
    simcInput.push "profileset.\"#{name}\"+=race=#{raceString}"
  end
end

simulationFilename = "RaceSimulation_#{fightstyle}_#{template}"
logFile = "#{SimcConfig['LogsFolder']}/#{simulationFilename}"
reportFile = "#{SimcConfig['ReportsFolder']}/#{simulationFilename}"
metaFile = "#{SimcConfig['ReportsFolder']}/meta/#{simulationFilename}.json"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcRaceConfig.simc",
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/Templates/#{classfolder}/#{template}.simc",
  simcInput
]
SimcHelper.RunSimulation(params, "#{SimcConfig['GeneratedFolder']}/#{simulationFilename}.simc")

# Read JSON Output
results = JSONResults.new("#{logFile}.json")

# Extract metadata
Logging.LogScriptInfo "Extract metadata from #{logFile}.json to #{metaFile}..."
results.extractMetadata(metaFile)

# Write report
Logging.LogScriptInfo "Processing data and writing report to #{reportFile}..."
report = [ ]
# Header
def hashElementType (value)
  return { "type" => value }
end
header = [ hashElementType("string"), hashElementType("number") ]
report.push(header)
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
