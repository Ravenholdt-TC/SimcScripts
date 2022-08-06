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

# Covenant templates, not great but hack enough to keep all legos in one chart i hope
simcInput.push "profileset.\"Template_Kyrian\"+=covenant=kyrian"
simcInput.push "profileset.\"Template_Night Fae\"+=covenant=night_fae"
simcInput.push "profileset.\"Template_Necrolord\"+=covenant=necrolord"
simcInput.push "profileset.\"Template_Venthyr\"+=covenant=venthyr"

# Get better combination overrides if CombinationBasedCharts is enabled. These will be run in addition to defaults.
combinationOverrides = HeroInterface.GetBestCombinationOverrides(fightstyle, template, talents)

# Create additional Template base profilesets for the talent overrides
additionalTalents = combinationOverrides.keys.collect { |x| (data = /.*talents:(\p{Digit}+).*\Z/.match(x)) ? data[1] : nil }.uniq.compact
additionalTalents.each do |talentString|
  simcInput.push "profileset.\"TalentTemplate_#{talentString}\"+=talents=#{talentString}"
  simcInput.push "profileset.\"TalentTemplate_Kyrian_#{talentString}\"+=talents=#{talentString}"
  simcInput.push "profileset.\"TalentTemplate_Kyrian_#{talentString}\"+=covenant=kyrian"
  simcInput.push "profileset.\"TalentTemplate_Night Fae_#{talentString}\"+=talents=#{talentString}"
  simcInput.push "profileset.\"TalentTemplate_Night Fae_#{talentString}\"+=covenant=night_fae"
  simcInput.push "profileset.\"TalentTemplate_Necrolord_#{talentString}\"+=talents=#{talentString}"
  simcInput.push "profileset.\"TalentTemplate_Necrolord_#{talentString}\"+=covenant=necrolord"
  simcInput.push "profileset.\"TalentTemplate_Venthyr_#{talentString}\"+=talents=#{talentString}"
  simcInput.push "profileset.\"TalentTemplate_Venthyr_#{talentString}\"+=covenant=venthyr"
end

# Add empty override set for the default loop
combinationOverrides[nil] = []

# Include potential lego copies
legoList += JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/LegendariesAdditional.json")

# TODO: Possibly refactor this into more customizable json input
LegoStatMap = {
  "Head/Chest/Legs Stats" => {
    #"190" => "58str_58agi_58int_58crit_58versatility",
    #"210" => "70str_70agi_70int_65crit_65versatility",
    #"225" => "80str_80agi_80int_71crit_71versatility",
    #"235" => "88str_88agi_88int_74crit_74versatility",
    "249" => "101str_101agi_101int_79crit_79versatility",
    "262" => "114str_114agi_114int_84crit_84versatility",
    "291" => "149str_149agi_149int_94crit_94versatility",
  },
  "Shoulders/Waist/Hands/Boots Stats" => {
    #"190" => "44str_44agi_44int_43crit_43versatility",
    #"210" => "53str_53agi_53int_48crit_48versatility",
    #"225" => "60str_60agi_60int_52crit_52versatility",
    #"235" => "66str_66agi_66int_55crit_55versatility",
    "249" => "76str_76agi_76int_59crit_59versatility",
    "262" => "85str_85agi_85int_63crit_63versatility",
    "291" => "112str_112agi_112int_71crit_71versatility",
  },
  "Back/Wrists Stats" => {
    #"190" => "33str_33agi_33int_32crit_32versatility",
    #"210" => "39str_39agi_39int_36crit_36versatility",
    #"225" => "45str_45agi_45int_39crit_39versatility",
    #"235" => "50str_50agi_50int_41crit_41versatility",
    "249" => "57str_57agi_57int_45crit_45versatility",
    "262" => "64str_64agi_64int_47crit_47versatility",
    "291" => "84str_84agi_84int_53crit_53versatility",
  },
  "Neck/Finger Stats" => {
    #"190" => "77crit_77versatility",
    #"210" => "95crit_95versatility",
    #"225" => "106crit_106versatility",
    #"235" => "115crit_115versatility",
    "249" => "126crit_126versatility",
    "262" => "137crit_137versatility",
    "291" => "160crit_160versatility",
  },
}

combinationOverrides.each do |optionsString, overrides|
  legoList.each do |lego|
    next unless lego["specs"].include?(specId)
    next if lego["legendaryName"].eql?("Unity")
    name = "#{lego["legendaryName"]}#{"--" if optionsString}#{optionsString}"
    name += "_#{lego["covenant"]}" if lego["covenant"]
    name += "_1"
    prefix = "profileset.\"#{name}\"+="
    simcInput.push(prefix + "name=\"#{name}\"")
    simcInput.push(prefix + "shirt=sl_legendary,bonus_id=#{lego["legendaryBonusID"]}")
    if lego["covenant"]
      covstr = lego["covenant"].downcase.gsub(" ", "_")
      simcInput.push(prefix + "covenant=\"#{covstr}\"")
    end
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
templateDPS_K = 0
templateDPS_NF = 0
templateDPS_N = 0
templateDPS_V = 0
talentDPS = {}
talentDPS_K = {}
talentDPS_N = {}
talentDPS_NF = {}
talentDPS_V = {}
columns = []
sims = {}
results.getAllDPSResults().each do |name, dps|
  if name.start_with?("TalentTemplate_Kyrian") # Thar be ugly hacks here
    talentString = name.split("_")[2]
    talentDPS_K[talentString] = dps
  elsif name.start_with?("TalentTemplate_Night Fae")
    talentString = name.split("_")[2]
    talentDPS_NF[talentString] = dps
  elsif name.start_with?("TalentTemplate_Necrolord")
    talentString = name.split("_")[2]
    talentDPS_N[talentString] = dps
  elsif name.start_with?("TalentTemplate_Venthyr")
    talentString = name.split("_")[2]
    talentDPS_V[talentString] = dps
  elsif name.start_with?("TalentTemplate_")
    talentString = name.split("_")[1]
    talentDPS[talentString] = dps
  elsif name == "Template"
    templateDPS = dps
  elsif name == "Template_Kyrian"
    templateDPS_K = dps
  elsif name == "Template_Night Fae"
    templateDPS_NF = dps
  elsif name == "Template_Necrolord"
    templateDPS_N = dps
  elsif name == "Template_Venthyr"
    templateDPS_V = dps
  elsif data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
    columns.push(data[2].to_i)
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
  actor.push(name.gsub("_Kyrian", "").gsub("_Night Fae", "").gsub("_Necrolord", "").gsub("_Venthyr", ""))
  columns.each do |col|
    if values[col]
      if (data = /.*talents:(\p{Digit}+).*\Z/.match(name)) && talentDPS[data[1]]
        compare = talentDPS[data[1]]
        if name.end_with?("_Kyrian")
          compare = talentDPS_K[data[1]]
        elsif name.end_with?("_Night Fae")
          compare = talentDPS_NF[data[1]]
        elsif name.end_with?("_Necrolord")
          compare = talentDPS_N[data[1]]
        elsif name.end_with?("_Venthyr")
          compare = talentDPS_V[data[1]]
        end
        actor.push(values[col] - compare)
      else
        compare = templateDPS
        if name.end_with?("_Kyrian")
          compare = templateDPS_K
        elsif name.end_with?("_Night Fae")
          compare = templateDPS_NF
        elsif name.end_with?("_Necrolord")
          compare = templateDPS_N
        elsif name.end_with?("_Venthyr")
          compare = templateDPS_V
        end
        actor.push(values[col] - compare)
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
