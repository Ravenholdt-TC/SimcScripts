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

Logging.Initialize("CorruptionSimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Templates")
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ""], classfolder)

corruptionsList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Corruptions.json")

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

# Using shirt slot for corruption testing
simcInput = []
Logging.LogScriptInfo "Generating profilesets..."
simcInput.push 'name="Template"'
simcInput.push "shirt="
simcInput.push ""

# Remove corruption bonus ids to support T25 sims
corruptionBonusIds = corruptionsList.collect { |x| x["tiers"].collect { |t| t["bonusId"] } }.flatten
simcInput.push "# Overrides with removed corruption bonus ids where present"
ProfileHelper.RemoveBonusIds(corruptionBonusIds, templateFile).each do |override|
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

combinationOverrides.each do |optionsString, overrides|
  corruptionsList.each do |corruption|
    corruption["tiers"].each do |tier|
      name = "#{corruption["name"]}#{"--" if optionsString}#{optionsString}_#{tier["corruption"]}"
      prefix = "profileset.\"#{name}\"+="
      simcInput.push(prefix + "name=\"#{name}\"")
      simcInput.push(prefix + "shirt=,id=52019,bonus_id=#{tier["bonusId"]}")
      if corruption["additionalInput"]
        corruption["additionalInput"].each do |input|
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

simulationFilename = "Corruptions-Absolute_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcCorruptionConfig.simc",
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
corruptionTiers = []
sims = {}
results.getAllDPSResults().each do |name, dps|
  if name.start_with?("TalentTemplate_")
    talentString = name.split("_")[1]
    talentDPS[talentString] = dps
  elsif data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
    corruptionTiers.push(data[2].to_i)
  elsif name == "Template"
    templateDPS = dps
  end
end
corruptionTiers.uniq!
corruptionTiers.sort!

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
reportRelative = []
# Headers
header = ["Corruption"]
corruptionTiers.each do |corr|
  header.push(corr.to_s)
end
report.push(header)
reportRelative.push(["Corruption", "DPS per Corruption"])
# Body
sims.each do |name, values|
  actor = []
  actorRelative = []
  actor.push(name)
  actorRelative.push(name)
  dpsPerCorrList = []
  corruptionTiers.each do |corr|
    tierVal = 0
    if values[corr]
      if (data = /.*talents:(\p{Digit}+).*\Z/.match(name)) && talentDPS[data[1]]
        tierVal = values[corr] - talentDPS[data[1]]
      else
        tierVal = values[corr] - templateDPS
      end
      dpsPerCorruption = tierVal.to_f / corr
      dpsPerCorrList.push(dpsPerCorruption)
    end
    actor.push(tierVal)
  end
  actorRelative.push(dpsPerCorrList.inject(:+).to_f / dpsPerCorrList.size) #Average DPS per corruption where values exist
  report.push(actor)
  reportRelative.push(actorRelative)
end

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)
ReportWriter.WriteArrayReport(results, reportRelative, ProfileHelper.NormalizeProfileName("Corruptions-Relative_#{fightstyle}_#{template}"))

Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
