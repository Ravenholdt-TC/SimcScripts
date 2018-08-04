require 'rubygems'
require 'bundler/setup'
require_relative 'lib/DataMaps'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/ReportWriter'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

Logging.Initialize("AzeriteSimulation")

fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')
classfolder = Interactive.SelectSubfolder('Templates')
spec = Interactive.SelectFromArray('Specialization', ClassAndSpecIds[classfolder][:specs].keys)
template = Interactive.SelectTemplate("Templates/#{classfolder}/")

powerList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeritePower.json")
powerSettings = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeriteOptions.json")

classId = ClassAndSpecIds[classfolder][:class_id]
specId = ClassAndSpecIds[classfolder][:specs][spec]

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
simcInput.push 'disable_azerite=items'
simcInput.push ''

simcInputLevels = []
simcInputStacks = []
powerList.each do |power|
  next if !power['classesId'].include?(classId)
  next if power['specId'] && !power['specId'].include?(specId)
  next if powerSettings.include?(power['powerId'])

  # Item Level Simulations
  powerSettings['itemLevels'].each do |ilvl|
    simcInputLevels.push "profileset.\"#{power['spellName']}_#{ilvl}\"+=azerite_override=#{power['powerId']}:#{ilvl}"
  end

  # Stack Simulations
  (1..3).each do |stacks|
    powerstring = (["#{power['powerId']}:#{powerSettings['baseItemLevel']}"] * stacks).join('/')
    simcInputStacks.push "profileset.\"#{power['spellName']}_#{stacks}\"+=azerite_override=#{powerstring}"
  end
end

##################################
# Process Item Level simulations #
##################################

simulationFilename = "AzeriteLevels_#{fightstyle}_#{template}"
templateFile = "#{SimcConfig['ProfilesFolder']}/Templates/#{classfolder}/#{template}.simc"
unless File.exist?(templateFile)
  Logging.LogScriptInfo "Template file not found, defaulting to SimC one."
  if template.start_with?('PR')
    tierFolder = 'PreRaids'
  else
    tierFolder = "Tier#{template[1..2]}"
  end
  templateFile = "#{SimcConfig['SimcPath']}/profiles/#{tierFolder}/#{template}.simc"
end
unless File.exist?(templateFile)
  Logging.LogScriptError("Unknown SimC template file (#{templateFile})!")
end
params = [
  "#{SimcConfig['ConfigFolder']}/SimcAzeriteConfig.simc",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  templateFile,
  simcInput + simcInputLevels
]
SimcHelper.RunSimulation(params, simulationFilename)

# Read JSON Output
results = JSONResults.new(simulationFilename)

# Process results
Logging.LogScriptInfo "Processing results..."
templateDPS = 0
iLevelList = []
sims = {}
results.getAllDPSResults().each do |name, dps|
  if data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
    iLevelList.push(data[2].to_i)
  elsif name == 'Template'
    templateDPS = dps
  end
end
iLevelList.uniq!
iLevelList.sort!

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
# Header
header = ["Trait"]
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
      actor.push(values[ilvl] - templateDPS)
    else
      actor.push(0)
    end
  end
  report.push(actor)
end

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

#############################
# Process Stack Simulations # (yes, welcome to copy pasta land, deal with it)
#############################

simulationFilename = "AzeriteStacks_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcAzeriteConfig.simc",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/Templates/#{classfolder}/#{template}.simc",
  simcInput + simcInputStacks,
]
SimcHelper.RunSimulation(params, simulationFilename)

# Read JSON Output
results = JSONResults.new(simulationFilename)

# Process results
Logging.LogScriptInfo "Processing results..."
templateDPS = 0
sims = {}
results.getAllDPSResults().each do |name, dps|
  if data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
  elsif name == 'Template'
    templateDPS = dps
  end
end

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
# Header
report.push ["Trait", "1", "2", "3"]
# Body
sims.each do |name, values|
  actor = []
  actor.push(name)
  (1..3).each do |stacks|
    if values[stacks]
      actor.push(values[stacks] - templateDPS)
    else
      actor.push(0)
    end
  end
  report.push(actor)
end

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

Logging.LogScriptInfo 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
