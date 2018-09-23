require 'rubygems'
require 'bundler/setup'
require_relative 'lib/DataMaps'
require_relative 'lib/HeroInterface'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/ProfileHelper'
require_relative 'lib/ReportWriter'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

Logging.Initialize("AzeriteSimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate('Fightstyles/Fightstyle_')
classfolder = Interactive.SelectSubfolder('Templates')
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ''], classfolder)

powerList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeritePower.json")
powerSettings = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeriteOptions.json")

classId = ClassAndSpecIds[classfolder][:class_id]

# Read spec from template profile
spec = ProfileHelper.GetValueFromTemplate('spec', templateFile)
unless spec
  Logging.LogScriptError "No spec= string found in profile!"
  exit
end
specId = ClassAndSpecIds[classfolder][:specs][spec]

# Read talents from template profile
talents = ProfileHelper.GetValueFromTemplate('talents', templateFile)
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
simcInput.push 'disable_azerite=items'
simcInput.push ''

# Get head slot from profile. We will scale this up together with the trait to account for main stat increase.
$headItemString = ProfileHelper.GetValueFromTemplate('head', templateFile)
unless $headItemString
  Logging.LogScriptError "No head= string found in profile!"
  exit
end

# Get Base item level for Stacks based on Profile name beginning
$stackPowerLevel = powerSettings['baseItemLevels'].first.last
powerSettings['baseItemLevels'].each do |prefix, ilvl|
  if template.start_with? prefix
    $stackPowerLevel = ilvl
    break
  end
end

# Get azerite combinations if CombinationBasedAzeriteCharts is enabled.
azeriteCombinations = HeroInterface.GetAzeriteCombinations(3, fightstyle, talents, template)

# Create simc inputs
$simcInputLevels = ["head=#{$headItemString},ilevel=#{powerSettings['itemLevels'].first}", '']
$simcInputStacks = []

def writePowerProfilesets (itemLevels, powerName, power, options = {})
  optionsString = (options.empty? ? '' : '--') + options.map { |k, v| "#{k}:#{v}" }.join(';')
  baseName = "#{powerName}#{optionsString}"

  # Item Level Simulations
  itemLevels.each do |ilvl|
    name = "#{baseName}_#{ilvl}"
    prefix = "profileset.\"#{name}\"+="
    $simcInputLevels.push(prefix + "name=\"#{name}\"")
    $simcInputLevels.push(prefix + "head=#{$headItemString},ilevel=#{ilvl}")
    $simcInputLevels.push(prefix + "azerite_override=#{power['powerId']}:#{ilvl}")
    $simcInputLevels.push(prefix + "talents=#{options['talents']}") if options['talents']
    $simcInputLevels.push(prefix + "bfa.reorigination_array_stacks=#{options['ra']}") if options['ra']
  end

  # Stack Simulations
  (1..3).each do |stacks|
    name = "#{baseName}_#{stacks}"
    prefix = "profileset.\"#{name}\"+="
    $simcInputStacks.push(prefix + "name=\"#{name}\"")
    powerstring = (["#{power['powerId']}:#{$stackPowerLevel}"] * stacks).join('/')
    $simcInputStacks.push(prefix + "azerite_override=#{powerstring}")
    $simcInputStacks.push(prefix + "talents=#{options['talents']}") if options['talents']
    $simcInputStacks.push(prefix + "bfa.reorigination_array_stacks=#{options['ra']}") if options['ra']
  end
end

powerList.each do |power|
  next if !power['classesId'].include?(classId)
  next if power['specsId'] && !power['specsId'].include?(specId)
  next if powerSettings['blacklistedTiers'].include?(power['tier'])
  next if powerSettings['blacklistedPowers'].include?(power['powerId'])

  powerName = power['spellName']
  pairedSet = powerSettings['pairedPowers'].find { |x| x.include? power['powerId'] }
  if pairedSet
    if power['powerId'] == pairedSet.first
      powerName = powerList.select { |x| pairedSet.include? x['powerId'] }.collect { |x| x['spellName'] }.join(' / ')
    else
      next
    end
  end

  # Sim per stacks for Reorigination Array if specified in options
  reoriginationArray = [0]
  if powerSettings['reoriginationArrayPowers'].include?(power['powerId'])
    reoriginationArray = powerSettings['reoriginationArrayStacks']
  end

  reoriginationArray.each do |raStacks|
    # Write the normal profilesets
    writePowerProfilesets(powerSettings['itemLevels'], powerName, power)

    # Set up additional options
    options = {}
    if azeriteCombinations
      if azeriteCombinations[powerName]
        if azeriteCombinations[powerName] != talents
          options['talents'] = azeriteCombinations[powerName]
        end
      elsif azeriteCombinations['Generic'] && azeriteCombinations['Generic'] != talents
        options['talents'] = azeriteCombinations['Generic']
      end
    end
    options['ra'] = raStacks if raStacks > 0
    writePowerProfilesets(powerSettings['itemLevels'], powerName, power, options) if !options.empty?
  end
end

##################################
# Process Item Level simulations #
##################################

simulationFilename = "Azerite-Levels_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcAzeriteConfig.simc",
  fightstyleFile,
  templateFile,
  simcInput + $simcInputLevels,
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

simulationFilename = "Azerite-Stacks_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcAzeriteConfig.simc",
  fightstyleFile,
  templateFile,
  simcInput + $simcInputStacks,
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
