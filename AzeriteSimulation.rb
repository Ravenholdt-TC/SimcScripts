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

fightstyle, fightstyleFile = Interactive.SelectTemplate('Fightstyles/Fightstyle_')
classfolder = Interactive.SelectSubfolder('Templates')
spec = Interactive.SelectFromArray('Specialization', ClassAndSpecIds[classfolder][:specs].keys)
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ''], classfolder)

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

# Get head slot from profile. We will scale this up together with the trait to account for main stat increase.
headItemString = ''
File.open(templateFile, 'r') do |tfile|
  while line = tfile.gets
    if line.start_with?('head=')
      headItemString = line.chomp
    end
  end
end

# Create simc inputs
simcInputLevels = ["#{headItemString},ilevel=#{powerSettings['itemLevels'].first}", '']
simcInputStacks = []
powerList.each do |power|
  next if !power['classesId'].include?(classId)
  next if power['specsId'] && !power['specsId'].include?(specId)
  next if powerSettings['blacklistedTiers'].include?(power['tier'])
  next if powerSettings['blacklistedPowerIds'].include?(power['powerId'])

  powerName = power['spellName']
  pairedSet = powerSettings['pairedPowers'].find { |x| x.include? power['powerId'] }
  if pairedSet
    if power['powerId'] == pairedSet.first
      powerName = powerList.select { |x| pairedSet.include? x['powerId'] }.collect { |x| x['spellName'] }.join(' / ')
    else
      next
    end
  end

  # Item Level Simulations
  powerSettings['itemLevels'].each do |ilvl|
    simcInputLevels.push "profileset.\"#{powerName}_#{ilvl}\"+=#{headItemString},ilevel=#{ilvl}"
    simcInputLevels.push "profileset.\"#{powerName}_#{ilvl}\"+=azerite_override=#{power['powerId']}:#{ilvl}"
  end

  # Stack Simulations
  (1..3).each do |stacks|
    powerstring = (["#{power['powerId']}:#{powerSettings['baseItemLevel']}"] * stacks).join('/')
    simcInputStacks.push "profileset.\"#{powerName}_#{stacks}\"+=azerite_override=#{powerstring}"
  end
end

##################################
# Process Item Level simulations #
##################################

simulationFilename = "AzeriteLevels_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcAzeriteConfig.simc",
  fightstyleFile,
  templateFile,
  simcInput + simcInputLevels,
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
  fightstyleFile,
  templateFile,
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
