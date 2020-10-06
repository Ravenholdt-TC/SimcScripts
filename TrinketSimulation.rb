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

Logging.Initialize("TrinketSimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Templates")
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ""], classfolder)
trinketListProfiles = Interactive.SelectTemplateMulti("TrinketLists/")

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
Logging.LogScriptInfo "-- Trinket List: #{trinketListProfiles}"
Logging.LogScriptInfo "-- Fightstyle: #{fightstyle}"
puts

simcInput = []
Logging.LogScriptInfo "Generating profilesets..."
simcInput.push 'name="Template"'
simcInput.push "trinket1=empty"
simcInput.push "trinket2=empty"

# 9.0 Prepatch HAX, remove me later
if template.start_with?("T25") || template.start_with?("DS")
  simcInput.push "level=50"
  simcInput.push "scale_itemlevel_down_only=1"
  simcInput.push "scale_to_itemlevel=145"
  simcInput.push "default_actions=1"
end

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

trinketListProfiles.each do |pname, pfile|
  trinketList = JSONParser.ReadFile(pfile)
  combinationOverrides.each do |optionsString, overrides|
    trinketList["trinkets"].each do |trinket|
      bonusIdString = trinket["bonusIds"].empty? ? "" : ",bonus_id=" + trinket["bonusIds"].join("/")
      trinket["itemLevels"].each do |ilvl|
        trinketString = trinket["itemId"]
        ilevelString = "ilevel=#{ilvl}"
        if trinket["gemmedInto"]
          trinketString = "#{trinket["gemmedInto"]},gem_id=#{trinket["itemId"]}"
          ilevelString += "gem_ilevel=#{ilvl}"
        end
        name = "#{trinket["name"]}#{"--" if optionsString}#{optionsString}_#{ilvl}"
        prefix = "profileset.\"#{name}\"+="
        simcInput.push(prefix + "name=\"#{name}\"")
        simcInput.push(prefix + "trinket1=,id=#{trinketString},#{ilevelString}#{bonusIdString}")
        trinket["additionalInput"].each do |input|
          simcInput.push(prefix + "#{input}")
        end
        overrides.each do |override|
          simcInput.push(prefix + "#{override}")
        end
      end
      simcInput.push ""
    end
  end
end

simulationFilename = "TrinketSimulation_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcTrinketConfig.simc",
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
iLevelList = []
sims = {}
results.getAllDPSResults().each do |name, dps|
  if name.start_with?("TalentTemplate_")
    talentString = name.split("_")[1]
    talentDPS[talentString] = dps
  elsif data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
    iLevelList.push(data[2].to_i)
  elsif name == "Template"
    templateDPS = dps
  end
end
iLevelList.uniq!
iLevelList.sort!

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
# Header
header = ["Trinket"]
iLevelList.each do |ilvl|
  header.push(ilvl.to_s)
end
report.push(header)
# Body
sims.each do |name, values|
  actor = []
  actor.push(name)
  iLevelList.each do |ilvl|
    if values[ilvl]
      if (data = /.*talents:(\p{Digit}+).*\Z/.match(name)) && talentDPS[data[1]]
        actor.push(values[ilvl] - talentDPS[data[1]])
      else
        actor.push(values[ilvl] - templateDPS)
      end
    else
      actor.push(0)
    end
  end
  report.push(actor)
end

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
