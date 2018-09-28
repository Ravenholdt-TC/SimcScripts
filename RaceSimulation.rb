require "rubygems"
require "bundler/setup"
require_relative "lib/DataMaps"
require_relative "lib/HeroInterface"
require_relative "lib/Interactive"
require_relative "lib/JSONResults"
require_relative "lib/Logging"
require_relative "lib/ReportWriter"
require_relative "lib/SimcConfig"
require_relative "lib/SimcHelper"

Logging.Initialize("RaceSimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Templates")
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ""], classfolder)

# Read talents from template profile
talents = ProfileHelper.GetValueFromTemplate("talents", templateFile)
unless talents
  Logging.LogScriptError "No talents= string found in profile!"
  exit
end

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
simcInput.push ""

# Get better combination overrides if CombinationBasedCharts is enabled. These will be run in addition to defaults.
combinationOverrides = HeroInterface.GetBestCombinationOverrides(fightstyle, template, talents)
# Add empty override set for the default loop
combinationOverrides[nil] = []

combinationOverrides.each do |optionsString, overrides|
  RaceInputMap.each do |name, raceString|
    if ClassRaceMap[classfolder].include?(name)
      psetName = "#{name}#{"--" if optionsString}#{optionsString}"
      prefix = "profileset.\"#{psetName}\"+="
      simcInput.push(prefix + "name=\"#{psetName}\"")
      simcInput.push(prefix + "race=#{raceString}")
      overrides.each do |override|
        simcInput.push(prefix + "#{override}")
      end
    end
  end
end

simulationFilename = "RaceSimulation_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcRaceConfig.simc",
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
templateDPS = sims["Template"] or 0
sims.delete("Template")

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

Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
