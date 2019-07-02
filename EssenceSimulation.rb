require "rubygems"
require "bundler/setup"
require_relative "lib/DataMaps"
require_relative "lib/HeroInterface"
require_relative "lib/Interactive"
require_relative "lib/JSONParser"
require_relative "lib/JSONResults"
require_relative "lib/Logging"
require_relative "lib/ProfileHelper"
require_relative "lib/ReportWriter"
require_relative "lib/SimcConfig"
require_relative "lib/SimcHelper"

Logging.Initialize("EssenceSimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Templates")
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ""], classfolder)

essenceList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/Essences.json")

classId = ClassAndSpecIds[classfolder][:class_id]

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
simcInput.push "azerite_essences="
simcInput.push "bfa.reorigination_array_stacks=0"
simcInput.push ""

# Get azerite combinations if CombinationBasedCharts is enabled. These will be run in addition to defaults.
essenceCombinations = HeroInterface.GetEssenceCombinations(fightstyle, template, talents)

# Create additional Template base profilesets for the talent overrides
additionalTalents = essenceCombinations.values.uniq.select { |x| x != talents }
additionalTalents.each do |talentString|
  simcInput.push "profileset.\"TalentTemplate_#{talentString}\"+=talents=#{talentString}"
end

# Add empty override set for the default loop
passes = ["default", "override"]

passes.each do |pass|
  essenceList.each do |essence|
    optionsString = nil
    bestTalents = essenceCombinations.dig(essence["name"])
    next if pass == "override" && (!bestTalents || bestTalents == talents)
    optionsString = "talents:#{bestTalents}" if pass == "override"
    ["Major", "Minor"].each do |type|
      (1..3).each do |rank|
        name = "#{essence["name"]} (#{type})#{"--" if optionsString}#{optionsString}_#{rank}"
        prefix = "profileset.\"#{name}\"+="
        simcInput.push(prefix + "name=\"#{name}\"")
        simcInput.push(prefix + "azerite_essences=#{essence["essenceId"]}:#{rank}:#{type == "Major" ? 1 : 0}")
        essence["additionalInput"].each do |input|
          simcInput.push(prefix + "#{input}")
        end
        if pass == "override"
          simcInput.push(prefix + "talents=\"#{bestTalents}\"")
        end
      end
    end
    simcInput.push ""
  end
end

simulationFilename = "Essences_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcEssenceConfig.simc",
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
  elsif data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
  elsif name == "Template"
    templateDPS = dps
  end
end

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
# Header
report.push ["Essence", "1", "2", "3"]
# Body
sims.each do |name, values|
  actor = []
  actor.push(name)
  (1..3).each do |stacks|
    if values[stacks]
      if (data = /.*talents:(\p{Digit}+).*\Z/.match(name)) && talentDPS[data[1]]
        actor.push(values[stacks] - talentDPS[data[1]])
      else
        actor.push(values[stacks] - templateDPS)
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
