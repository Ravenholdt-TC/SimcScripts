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
simcInput.push ""

legoList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Legendaries.json")

# Create overrides with legendary bonus_ids removed from input
legoBonusIds = legoList.collect { |x| x["legendaryBonusID"] }
simcInput.push "# Overrides with removed legendary bonus ids where present"
ProfileHelper.RemoveBonusIds(legoBonusIds, templateFile).each do |override|
  simcInput.push override
end
simcInput.push "# Overrides done!"
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

# Include potential lego copies
legoList += JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/LegendariesAdditional.json")

# TODO: Possibly refactor this into more customizable json input
LegoStatMap = {
  "Head/Chest/Legs Stats" => {
    "1" => "58str_58agi_58int_58crit_58versatility",
    "2" => "70str_70agi_70int_65crit_65versatility",
    "3" => "80str_80agi_80int_71crit_71versatility",
    "4" => "88str_88agi_88int_74crit_74versatility",
  },
  "Shoulders/Waist/Hands/Boots Stats" => {
    "1" => "44str_44agi_44int_43crit_43versatility",
    "2" => "53str_53agi_53int_48crit_48versatility",
    "3" => "60str_60agi_60int_52crit_52versatility",
    "4" => "66str_66agi_66int_55crit_55versatility",
  },
  "Back/Wrists Stats" => {
    "1" => "33str_33agi_33int_32crit_32versatility",
    "2" => "39str_39agi_39int_36crit_36versatility",
    "3" => "45str_45agi_45int_39crit_39versatility",
    "4" => "50str_50agi_50int_41crit_41versatility",
  },
  "Neck/Finger Stats" => {
    "1" => "77crit_77versatility",
    "2" => "95crit_95versatility",
    "3" => "106crit_106versatility",
    "4" => "115crit_115versatility",
  },
}

combinationOverrides.each do |optionsString, overrides|
  legoList.each do |lego|
    next unless lego["specs"].include?(specId)
    name = "#{lego["legendaryName"]}#{"--" if optionsString}#{optionsString}_1"
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
  LegoStatMap.each do |slotsName, rankMap|
    rankMap.each do |rank, statStr|
      name = "#{slotsName}#{"--" if optionsString}#{optionsString}_#{rank}"
      prefix = "profileset.\"#{name}\"+="
      simcInput.push(prefix + "name=\"#{name}\"")
      simcInput.push(prefix + "shirt=sl_legendary,stats=#{statStr}")
      overrides.each do |override|
        simcInput.push(prefix + "#{override}")
      end
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
header = ["Legendary"]
columns.each do |col|
  header.push(col.to_s)
end
report.push(header)
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
