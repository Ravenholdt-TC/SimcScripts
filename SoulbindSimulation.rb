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

Logging.Initialize("SoulbindSimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Templates")
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ""], classfolder)
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

covenant = Interactive.SelectFromArray("Covenant", ["Kyrian", "Necrolord", "Night-Fae", "Venthyr"])
covenant_simc = covenant.downcase.gsub("-", "_")

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
simcInput.push "covenant=" + covenant_simc
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

conduitList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Conduits.json")
soulbindSettings = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/SoulbindSettings.json")
combinationOverrides.each do |optionsString, overrides|
  # Generate soulbind profiles
  soulbindSettings["soulbindSims"].each do |soulbind_trait|
    next if soulbind_trait["covenant"] != covenant_simc
    name = "#{soulbind_trait["spellName"]} (#{soulbind_trait["soulbindName"]})#{"--" if optionsString}#{optionsString}_1"
    prefix = "profileset.\"#{name}\"+="
    simcInput.push(prefix + "name=\"#{name}\"")
    simcInput.push(prefix + "soulbind=#{soulbind_trait["spellId"]}")
    if soulbind_trait["additionalInput"]
      soulbind_trait["additionalInput"].each do |input|
        simcInput.push(prefix + "#{input}")
      end
    end
    overrides.each do |override|
      simcInput.push(prefix + "#{override}")
    end
    simcInput.push ""
  end
  # Generate conduit profiles
  conduitList.each do |conduit|
    next unless conduit["specs"].include?(specId)
    next unless conduit["conduitType"] == 1
    specific_covenant = soulbindSettings["covenantConduitsMap"][conduit["conduitSpellID"].to_s]
    next if specific_covenant && specific_covenant != covenant_simc
    soulbindSettings["conduitRanks"].each do |rank|
      name = "#{conduit["conduitName"]}#{"--" if optionsString}#{optionsString}_#{rank}"
      prefix = "profileset.\"#{name}\"+="
      simcInput.push(prefix + "name=\"#{name}\"")
      simcInput.push(prefix + "soulbind=#{conduit["conduitId"]}:#{rank}")
      if conduit["additionalInput"]
        conduit["additionalInput"].each do |input|
          simcInput.push(prefix + "#{input}")
        end
      end
      overrides.each do |override|
        simcInput.push(prefix + "#{override}")
      end
    end
    simcInput.push ""
  end
end

simulationFilename = "SoulbindSimulation_#{fightstyle}_#{template}_#{covenant}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcSoulbindConfig.simc",
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
columns = []
sims = {}
results.getAllDPSResults().each do |name, dps|
  if name.start_with?("TalentTemplate_")
    talentString = name.split("_")[1]
    talentDPS[talentString] = dps
  elsif data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
    columns.push(data[2].to_i)
  elsif name == "Template"
    templateDPS = dps
  end
end
columns.uniq!
columns.sort!

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
# Header
header = ["Power"]
columns.each do |col|
  header.push(col.to_s)
end
report.push(header)
# Body
sims.each do |name, values|
  actor = []
  actor.push(name)
  columns.each do |col|
    if values[col]
      if (data = /.*talents:(\p{Digit}+).*\Z/.match(name)) && talentDPS[data[1]]
        actor.push(values[col] - talentDPS[data[1]])
      else
        actor.push(values[col] - templateDPS)
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
