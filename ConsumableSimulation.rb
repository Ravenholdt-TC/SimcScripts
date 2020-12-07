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

Logging.Initialize("ConsumableSimulation")

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
simcInput.push 'food=disabled'
simcInput.push 'flask=disabled'
simcInput.push 'potion=disabled'
simcInput.push 'augmentation=disabled'
simcInput.push 'temporary_enchant=disabled'
simcInput.push ""

consumableList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Consumables.json")
useOilTemplates = consumableList.any? {|x| x["specs"].include?(specId) && x["useOilTemplate"]}
oilProfilesets = []

# Additional template with shadowcore oil for potion interactions
simcInput.push("profileset.\"Oil_Template\"+=temporary_enchant=main_hand:shadowcore_oil") if useOilTemplates

# Get better combination overrides if CombinationBasedCharts is enabled. These will be run in addition to defaults.
combinationOverrides = HeroInterface.GetBestCombinationOverrides(fightstyle, template, talents)

# Create additional Template base profilesets for the talent overrides
additionalTalents = combinationOverrides.keys.collect { |x| (data = /.*talents:(\p{Digit}+).*\Z/.match(x)) ? data[1] : nil }.uniq.compact
additionalTalents.each do |talentString|
  simcInput.push "profileset.\"TalentTemplate_#{talentString}\"+=talents=#{talentString}"
  if useOilTemplates
    simcInput.push "profileset.\"Oil_TalentTemplate_#{talentString}\"+=talents=#{talentString}"
    simcInput.push "profileset.\"Oil_TalentTemplate_#{talentString}\"+=temporary_enchant=main_hand:shadowcore_oil"
  end
end

# Add empty override set for the default loop
combinationOverrides[nil] = []

combinationOverrides.each do |optionsString, overrides|
  # Generate soulbind profiles
  consumableList.each do |consumable|
    next if !consumable["specs"].include?(specId)
    name = "#{consumable["name"]}#{"--" if optionsString}#{optionsString}_1"
    prefix = "profileset.\"#{name}\"+="
    simcInput.push(prefix + "name=\"#{name}\"")
    inputValue = consumable["value"] ? consumable["value"] : SimcHelper.TokenizeName(consumable["name"])
    simcInput.push(prefix + "#{consumable["type"]}=#{inputValue}")
    overrides.each do |override|
      simcInput.push(prefix + "#{override}")
    end
    if consumable["useOilTemplate"]
      simcInput.push(prefix + "temporary_enchant=main_hand:shadowcore_oil")
      oilProfilesets.push(name)
    end
    simcInput.push ""
  end
end

simulationFilename = "ConsumableSimulation_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcConsumableConfig.simc",
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
oilTemplateDPS = 0
talentDPS = {}
oilTalentDPS = {}
sims = {}
results.getAllDPSResults().each do |name, dps|
  if name.start_with?("TalentTemplate_")
    talentString = name.split("_")[1]
    talentDPS[talentString] = dps
  elsif name.start_with?("Oil_TalentTemplate_")
    talentString = name.split("_")[2]
    oilTalentDPS[talentString] = dps
  elsif name == "Template"
    templateDPS = dps
  elsif name == "Oil_Template"
    oilTemplateDPS = dps
  else
    sims[name] = dps
  end
end

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
  useOil = oilProfilesets.include?(name)
  compareDPS = useOil ? oilTemplateDPS : templateDPS
  if (data = /.*talents:(\p{Digit}+).*\Z/.match(name))
    compareDPS = useOil ? oilTalentDPS[data[1]] : talentDPS[data[1]]
  end
  actor = [name, value - compareDPS]
  report.push(actor)
end

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
