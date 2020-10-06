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

Logging.Initialize("AzeriteSimulation")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Templates")
template, templateFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ""], classfolder)

powerList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/AzeritePower.json")
powerSettings = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/AzeriteOptions.json")

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
simcInput.push "disable_azerite=items"
simcInput.push "bfa.reorigination_array_stacks=0"
simcInput.push "shirt="

# 9.0 Prepatch HAX, remove me later
if template.start_with?("T25") || template.start_with?("DS")
  simcInput.push "level=50"
  simcInput.push "scale_itemlevel_down_only=1"
  simcInput.push "scale_to_itemlevel=145"
  simcInput.push "default_actions=1"
end

simcInput.push ""

# Get head slot from profile. We will scale this up together with the trait to account for main stat increase.
$headItemString = ProfileHelper.GetValueFromTemplate("head", templateFile)
unless $headItemString
  Logging.LogScriptError "No head= string found in profile!"
  exit
end

# Get Base item level for Stacks based on Profile name beginning
$stackPowerLevel = powerSettings["baseItemLevels"].first.last
powerSettings["baseItemLevels"].each do |prefix, ilvl|
  if template.start_with? prefix
    $stackPowerLevel = ilvl
    break
  end
end

# Get azerite combinations if CombinationBasedCharts is enabled. These will be run in addition to defaults.
azeriteCombinations = HeroInterface.GetAzeriteCombinations(fightstyle, template, talents)

# Create additional Template base profilesets for the talent overrides
additionalTalents = azeriteCombinations.values.uniq.select { |x| x != talents }
additionalTalents.each do |talentString|
  simcInput.push "profileset.\"TalentTemplate_#{talentString}\"+=talents=#{talentString}"
end

# Special checks for Reorigination Array
enabledRA = false
if powerSettings["reoriginationArrayProfileWhitelist"].any? { |x| template.start_with?(x) } && !powerSettings["reoriginationArrayFightstyleBlacklist"].include?(fightstyle)
  enabledRA = true
end

# Create simc inputs
$simcInputLevels = ["head=#{$headItemString},ilevel=#{powerSettings["itemLevels"].first}", ""]
$simcInputStacks = []

def writePowerProfilesets(itemLevels, powerName, power, additionalInput = [], options = {})
  optionsString = (options.empty? ? "" : "--") + options.map { |k, v| "#{k}:#{v}" }.join(";")
  baseName = "#{powerName}#{optionsString}"

  # Item Level Simulations
  itemLevels.each do |ilvl|
    name = "#{baseName}_#{ilvl}"
    prefix = "profileset.\"#{name}\"+="
    $simcInputLevels.push(prefix + "name=\"#{name}\"")
    $simcInputLevels.push(prefix + "head=#{$headItemString},ilevel=#{ilvl}")
    $simcInputLevels.push(prefix + "azerite_override=#{power["powerId"]}:#{ilvl}")
    $simcInputLevels.push(prefix + "talents=#{options["talents"]}") if options["talents"]
    $simcInputLevels.push(prefix + "bfa.reorigination_array_stacks=#{options["ra"]}") if options["ra"]
    additionalInput.each do |add|
      $simcInputLevels.push(prefix + add)
    end
  end

  # Stack Simulations
  (1..3).each do |stacks|
    name = "#{baseName}_#{stacks}"
    prefix = "profileset.\"#{name}\"+="
    $simcInputStacks.push(prefix + "name=\"#{name}\"")
    powerstring = (["#{power["powerId"]}:#{$stackPowerLevel}"] * stacks).join("/")
    $simcInputStacks.push(prefix + "azerite_override=#{powerstring}")
    $simcInputStacks.push(prefix + "talents=#{options["talents"]}") if options["talents"]
    $simcInputStacks.push(prefix + "bfa.reorigination_array_stacks=#{options["ra"]}") if options["ra"]
    additionalInput.each do |add|
      $simcInputStacks.push(prefix + add)
    end
  end
end

# Special Hacky Powerlist Prefiltering in case we have duplicates. Should prolly be fixed elsewhere but do it as failsafe.
# Write all processed power Names to this array, skip if we already ran it.
processedPowers = []

powerList.each do |power|
  next if !power["classesId"].include?(classId)
  next if power["specsId"] && !power["specsId"].include?(specId)
  next if powerSettings["blacklistedTiers"].include?(power["tier"])
  next if powerSettings["blacklistedPowers"].include?(power["powerId"])

  powerName = power["spellName"]
  next if processedPowers.include?(powerName)
  processedPowers.push(powerName)

  pairedSet = powerSettings["pairedPowers"].find { |x| x.include? power["powerId"] }
  if pairedSet
    if power["powerId"] == pairedSet.first
      powerName = powerList.select { |x| pairedSet.include? x["powerId"] }.collect { |x| x["spellName"] }.join(" / ")
    else
      next
    end
  end

  additionalInput = powerSettings["additionalPowerInputs"][power["powerId"].to_s] || []

  # Sim per stacks for Reorigination Array if specified in options
  reoriginationArray = [0]
  if enabledRA && powerSettings["reoriginationArrayPowers"].include?(power["powerId"])
    reoriginationArray = powerSettings["reoriginationArrayStacks"]
  end

  reoriginationArray.each do |raStacks|
    # Write the normal profilesets
    writePowerProfilesets(powerSettings["itemLevels"], powerName, power, additionalInput)

    addedProfile = powerSettings["additionalPowerProfiles"].find { |x| x["powerId"] == power["powerId"] }
    if addedProfile
      writePowerProfilesets(powerSettings["itemLevels"], "#{powerName} (#{addedProfile["variantName"]})", power, additionalInput + addedProfile["additionalOptions"])
    end

    # Set up additional options
    options = {}
    if azeriteCombinations[powerName]
      if azeriteCombinations[powerName] != talents
        options["talents"] = azeriteCombinations[powerName]
      end
    elsif azeriteCombinations["Generic"] && azeriteCombinations["Generic"] != talents
      options["talents"] = azeriteCombinations["Generic"]
    end
    options["ra"] = raStacks if raStacks > 0
    if !options.empty?
      writePowerProfilesets(powerSettings["itemLevels"], powerName, power, additionalInput, options)
      if addedProfile
        writePowerProfilesets(powerSettings["itemLevels"], "#{powerName} (#{addedProfile["variantName"]})", power, additionalInput + addedProfile["additionalOptions"], options)
      end
    end
  end
end

##################################
# Process Item Level simulations #
##################################

=begin
simulationFilename = "Azerite-Levels_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcAzeriteConfig.simc",
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
=end

#############################
# Process Stack Simulations # (yes, welcome to copy pasta land, deal with it)
#############################

simulationFilename = "Azerite-Stacks_#{fightstyle}_#{template}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcAzeriteConfig.simc",
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
report.push ["Trait", "1", "2", "3"]
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
