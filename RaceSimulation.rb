require 'rubygems'
require 'bundler/setup'
require_relative 'lib/DataMaps'
require_relative 'lib/Interactive'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/ReportWriter'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

Logging.Initialize("RaceSimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate('Fightstyles/Fightstyle_')
classfolder = Interactive.SelectSubfolder('Templates')
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ''], classfolder)

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
RaceInputMap.each do |name, raceString|
  if ClassRaceMap[classfolder].include?(name)
    simcInput.push "profileset.\"#{name}\"+=race=#{raceString}"
  end
end

simulationFilename = "RaceSimulation_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcRaceConfig.simc",
  fightstyleFile,
  templateFile,
  simcInput,
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
report = []
# Header
def hashElementType(value)
  return {"type" => value}
end

header = [hashElementType("string"), hashElementType("number")]
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
