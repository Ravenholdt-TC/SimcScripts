require "rubygems"
require "bundler/setup"
require_relative "lib/Interactive"
require_relative "lib/JSONParser"
require_relative "lib/JSONResults"
require_relative "lib/Logging"
require_relative "lib/ProfileHelper"
require_relative "lib/ReportWriter"
require_relative "lib/SimcConfig"
require_relative "lib/SimcHelper"
require_relative "lib/HeroInterface"

Logging.Initialize("Combinator")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Templates")
profile, profileFile = Interactive.SelectTemplate(["Templates/#{classfolder}/", ""], classfolder)

#Read spec from profile
spec = ProfileHelper.GetValueFromTemplate("spec", profileFile)
unless spec
  Logging.LogScriptError "No spec= string found in profile!"
  exit
end

# Read talents from template profile
talents = ProfileHelper.GetValueFromTemplate("talents", profileFile)
unless talents
  Logging.LogScriptError "No talents= string found in profile!"
  exit
end

gearProfile, gearProfileFile = Interactive.SelectTemplate("Combinator/CombinatorGear_")
talentdatasets = Interactive.SelectTalentPermutations(talents)

# Log all interactively set settings
puts
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Fightstyle: #{fightstyle}"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Profile: #{profile}"
Logging.LogScriptInfo "-- Gear: #{gearProfile}"
Logging.LogScriptInfo "-- Talents: #{talentdatasets}"
puts

# Read gear setups from JSON
gear = YAML.load(File.read(gearProfileFile))

# Step by step cross products with requirement checks
rawCombinations = []
gear["combinatorSlots"].each.with_index(1) do |slot, slotNum|
  gear[slot]["options"].delete_if { |x| x["requires"] && x["requires"]["spec"] && !x["requires"]["spec"].include?(spec) }
  newOptions = gear[slot]["options"]

  if slotNum > 1
    rawCombinations = rawCombinations.product(newOptions) # Cross product everything
    rawCombinations = rawCombinations.collect(&:flatten) # Remove inner nested arrays
  else
    rawCombinations = newOptions.collect { |x| [x] } # Create nested arrays for first/single slot combinations
  end

  # Delete invalid combinations via requirements
  rawCombinations.delete_if do |combination|
    delete = false
    combination.each_with_index do |part, idx|
      combinatorSlot = gear[gear["combinatorSlots"][idx]]
      combinatorOption = part
      # Check requirements
      if combinatorOption["requires"]
        combinatorOption["requires"].each do |reqSlot, req|
          next if reqSlot == "spec" # handled above
          refidx = gear["combinatorSlots"].index(reqSlot)
          req = [req] if req.is_a?(String)
          delete = true if !req.include?(combination[refidx]["name"])
        end
      end
    end
    next delete
  end

  # Final cleanups, after checking requirements because there might be duplicate options with different requirements
  rawCombinations = rawCombinations.collect { |x| x.uniq { |y| y["name"] } } # Everything inside should be unique (AAB -> AB)
  rawCombinations = rawCombinations.select { |x| x.length == slotNum } # Only desired amount of combinator slots
  rawCombinations = rawCombinations.uniq { |x| x.sort_by { |y| y["name"] } } # Only generally unique combinations (no ABC and ACB)
end

# Build gear combination inputs
gearCombinations = {}
rawCombinations.each do |combination|
  inputStringsBySimcSlot = {}
  names = combination.collect { |x| x["name"] }
  hideFromName = []

  # Go through slots
  combination.each_with_index do |part, idx|
    combinatorSlot = gear[gear["combinatorSlots"][idx]]
    combinatorOption = part
    hideFromName.push(combinatorOption["name"]) if combinatorOption["hidden"]

    # Fetch simc input info
    next unless combinatorSlot["simcSlot"] # Skip virtual slots
    next unless combinatorOption["simcString"] # Skip virtual options
    inputStringsBySimcSlot[combinatorSlot["simcSlot"]] ||= []
    inputStringsBySimcSlot[combinatorSlot["simcSlot"]].push(combinatorOption["simcString"])
    if combinatorOption["additionalInput"]
      combinatorOption["additionalInput"].each do |add|
        inputStringsBySimcSlot[add["simcSlot"]] ||= []
        inputStringsBySimcSlot[add["simcSlot"]].push(add["simcString"])
      end
    end
  end

  # Generate and store actual simc input
  inputStrings = []
  inputStringsBySimcSlot.each do |slot, arr|
    inputStrings.push("#{slot}=#{arr.join("/")}")
  end
  nameArr = names - hideFromName
  profileName = nameArr.join("_")
  gearCombinations[profileName] = inputStrings
end

# Debug write
#File.open("temp.yml", "w") { |file| file.write(gearCombinations.to_yaml) }
#exit

# Combine gear with talents and write simc input to file
simcInput = []
simcInput.push "name=Template"

if gear["legendary"]
  # Create overrides with legendary bonus_ids removed from input
  legoList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Legendaries.json")
  legoBonusIds = legoList.collect { |x| x["legendaryBonusID"] }
  simcInput.push "# Overrides with removed legendary bonus ids where present"
  ProfileHelper.RemoveBonusIds(legoBonusIds, profileFile).each do |override|
    simcInput.push override
  end
  simcInput.push "# Overrides done!"
end

simcInput.push ""

Logging.LogScriptInfo "Generating combinations..."
talentdatasets.each do |talentdata|
  talentdata[0].each do |t1|
    talentdata[1].each do |t2|
      talentdata[2].each do |t3|
        talentdata[3].each do |t4|
          talentdata[4].each do |t5|
            talentdata[5].each do |t6|
              talentdata[6].each do |t7|
                talentInput = "#{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7}"
                talentOverrides = ProfileHelper.GetTalentOverrides("Combinator/#{classfolder}/TalentOverrides/#{profile}", talentInput)
                gearCombinations.each do |gearName, strings|
                  name = "#{talentInput}_#{gearName}"
                  prefix = "profileset.\"#{name}\"+="
                  simcInput.push(prefix + "name=\"#{name}\"")
                  simcInput.push(prefix + "talents=#{talentInput}")
                  talentOverrides.each do |talentOverride|
                    simcInput.push(prefix + talentOverride)
                  end
                  strings.each do |string|
                    simcInput.push(prefix + string)
                  end
                  simcInput.push ""
                end
              end
            end
          end
        end
      end
    end
  end
end

# Special naming extensions
combinatorStyle = ""
if gear["combinatorExtension"]
  combinatorStyle = "-#{gear["combinatorExtension"]}"
end
combinatorVariation = ""
if gear["combinatorVariation"]
  combinatorVariation = "_#{gear["combinatorVariation"]}"
end

simulationFilename = "Combinator#{combinatorStyle}_#{fightstyle}_#{profile}#{combinatorVariation}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcCombinatorConfig.simc",
  fightstyleFile,
  profileFile,
  simcInput,
]
if SimcConfig["CombinatorUseMultiStage"]
  SimcHelper.RunMultiStageSimulation(params, simulationFilename)
else
  SimcHelper.RunSimulation(params, simulationFilename)
end

# Process results
Logging.LogScriptInfo "Processing results..."
results = JSONResults.new(simulationFilename, SimcConfig["CombinatorUseMultiStage"])
sims = results.getAllDPSResults()
sims.delete("Template")
priorityDps = results.getPriorityDPSResults()

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
sims.each do |name, value|
  actor = []
  # Split profile name (mostly for web display)
  if data = name.match(/\A(\d+)_?([^;]*)\Z/)
    # Talents
    actor.push(data[1])
    # Gear
    if not data[2].empty?
      gearName = data[2].gsub(/_/, "; ")
    else
      gearName = "None"
    end
    actor.push(gearName)
  else
    # We should not get here, but leave it as failsafe
    Logging.LogScriptError "Matching result name failed: #{name}"
    actor.push(name)
  end
  actor.push(value) # DPS
  actor.push(priorityDps[name]) if priorityDps[name] # Priority DPS
  report.push(actor)
end
# Sort the report by the DPS value in DESC order
report.sort! { |x, y| y[2] <=> x[2] }
# Add the initial rank
report.each_with_index { |actor, index|
  actor.unshift(index + 1)
}

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

puts
Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
