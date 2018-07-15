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

fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')
classfolder = Interactive.SelectSubfolder('Templates')
template = Interactive.SelectTemplate("Templates/#{classfolder}/")

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
simcInput.push 'race=""'
simcInput.push ''
RaceMap.each do |name, raceString|
  if ClassMap[classfolder].include?(name)
    simcInput.push "profileset.\"#{name}\"+=race=#{raceString}"
  end
end

simulationFilename = "RaceSimulation_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcRaceConfig.simc",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/Templates/#{classfolder}/#{template}.simc",
  simcInput
]
SimcHelper.RunSimulation(params, simulationFilename)

# Read JSON Output
results = JSONResults.new(simulationFilename)

# Process results
Logging.LogScriptInfo "Processing results..."
sims = results.getAllDPSResults()
templateDPS = sims['Template'] or 0
sims.delete('Template')

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = [ ]
# Header
def hashElementType (value)
  return { "type" => value }
end
header = [ hashElementType("string"), hashElementType("number") ]
report.push(header)
# Body
sims.each do |name, value|
  actor = [name, value - templateDPS]
  report.push(actor)
end

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

Logging.LogScriptInfo 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
