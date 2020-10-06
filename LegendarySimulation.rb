require "rubygems"
require "bundler/setup"
require_relative "lib/HeroInterface"
require_relative "lib/Interactive"
require_relative "lib/JSONParser"
require_relative "lib/JSONResults"
require_relative "lib/Logging"
require_relative "lib/ReportWriter"
require_relative "lib/SimcConfig"
require_relative "lib/SimcHelper"
require_relative "lib/DataMaps"

Logging.Initialize("LegendarySimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Templates")
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ""], classfolder)

# Read spec from template profile
spec = ProfileHelper.GetValueFromTemplate("spec", templateFile)
unless spec
  Logging.LogScriptError "No spec= string found in profile!"
  exit
end
specId = ClassAndSpecIds[classfolder][:specs][spec]

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
simcInput.push "shirt=empty"
simcInput.push "covenant=none"
simcInput.push "soulbind="
simcInput.push ""

# Get better combination overrides if CombinationBasedCharts is enabled. These will be run in addition to defaults.
combinationOverrides = HeroInterface.GetBestCombinationOverrides(fightstyle, template, talents)

# Create additional Template base profilesets for the talent overrides
additionalTalents = combinationOverrides.keys.collect { |x| (data = /.*talents:(\p{Digit}+).*\Z/.match(x)) ? data[1] : nil }.uniq.compact
additionalTalents.each do |talentString|
  simcInput.push "profileset.\"TalentTemplate_#{talentString}\"+=talents=#{talentString}"
end

# Add empty override set for the default loop
combinationOverrides[nil] = []

legoList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Legendaries.json")
legoList += JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/LegendariesAdditional.json")
combinationOverrides.each do |optionsString, overrides|
  legoList.each do |lego|
    next unless lego["specs"].include?(specId)
    name = "#{lego["legendaryName"]}#{"--" if optionsString}#{optionsString}"
    prefix = "profileset.\"#{name}\"+="
    simcInput.push(prefix + "name=\"#{name}\"")
    simcInput.push(prefix + "shirt=sl_legendary,bonus_id=#{lego["legendaryBonusID"]}")
    if lego["additionalInput"]
      lego["additionalInput"].each do |input|
        simcInput.push(prefix + "#{input}")
      end
    end
    overrides.each do |override|
      simcInput.push(prefix + "#{override}")
    end
    simcInput.push ""
  end
end

simulationFilename = "LegendarySimulation_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcLegendaryConfig.simc",
  fightstyleFile,
  templateFile,
  simcInput,
]
SimcHelper.RunSimulation(params, simulationFilename)

# Read JSON Output
results = JSONResults.new(simulationFilename)

# Process results
Logging.LogScriptInfo "Processing results..."
templateDPS = 0
talentDPS = {}
sims = {}
results.getAllDPSResults().each do |name, dps|
  if name.start_with?("TalentTemplate_")
    talentString = name.split("_")[1]
    talentDPS[talentString] = dps
  elsif name == "Template"
    templateDPS = dps
  else
    sims[name] = dps
  end
end

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
header = ["Legendary", "DPS"]
report.push(header)
sims.each do |name, value|
  actor = [name, value - templateDPS]
  if (data = /.*talents:(\p{Digit}+).*\Z/.match(name)) && talentDPS[data[1]]
    actor = [name, value - talentDPS[data[1]]]
  end
  report.push(actor)
end

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
