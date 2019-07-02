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

Logging.Initialize("Combinator")

fightstyle, fightstyleFile = Interactive.SelectTemplate("Fightstyles/Fightstyle_")
classfolder = Interactive.SelectSubfolder("Combinator")
profile, profileFile = Interactive.SelectTemplate(["Combinator/#{classfolder}/Combinator_", "Templates/#{classfolder}/", ""], classfolder)
#Read spec from profile
spec = ProfileHelper.GetValueFromTemplate("spec", profileFile)
unless spec
  Logging.LogScriptError "No spec= string found in profile!"
  exit
end
gearProfile, gearProfileFile = Interactive.SelectTemplate("Combinator/#{classfolder}/CombinatorGear_")
setupsProfile, setupsProfileFile = Interactive.SelectTemplate("Combinator/CombinatorSetups_")
talentdata = Interactive.SelectTalentPermutations()

# Log all interactively set settings
puts
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Profile: #{profile}"
Logging.LogScriptInfo "-- Gear: #{gearProfile}"
Logging.LogScriptInfo "-- Setups: #{setupsProfile}"
Logging.LogScriptInfo "-- Fightstyle: #{fightstyle}"
Logging.LogScriptInfo "-- Talents: #{talentdata}"
puts

# Read gear setups from JSON
gear = JSONParser.ReadFile(gearProfileFile)
setups = JSONParser.ReadFile(setupsProfileFile)

# Duplicate two-slot items
gear["specials"][spec]["finger2"] = gear["specials"][spec]["finger1"]
gear["specials"][spec]["trinket2"] = gear["specials"][spec]["trinket1"]

# Duplicate Azerite as "six slots"
gear["specials"][spec]["azerite2"] = gear["specials"][spec]["azerite"]
gear["specials"][spec]["azerite3"] = gear["specials"][spec]["azerite"]
gear["specials"][spec]["azerite4"] = gear["specials"][spec]["azerite"]
gear["specials"][spec]["azerite5"] = gear["specials"][spec]["azerite"]
gear["specials"][spec]["azerite6"] = gear["specials"][spec]["azerite"]

# Duplicate Essences as 3 slots
gear["specials"][spec]["essenceMinor2"] = gear["specials"][spec]["essenceMinor"]

hasAnyAzerite = false
hasAnyEssences = false

# Get base item level for azerite stacks based on Profile name beginning
hasAnyAzerite = true if setupsProfile == "NoAzerite" # Disable azerite for 0A sims.
powerSettings = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/AzeriteOptions.json")
stackPowerLevel = powerSettings["baseItemLevels"].first.last
powerSettings["baseItemLevels"].each do |prefix, ilvl|
  if profile.start_with? prefix
    stackPowerLevel = ilvl
    break
  end
end

# Import essence list in case we need the additonal inputs
essenceList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/Essences.json")

# Build gear combinations
gearCombinations = {}
setups["setups"].each do |setup|
  setup["specials"].each do |numSpecials|
    # Iterate over legendary slot combinations
    gear["specials"][spec].keys.combination(numSpecials).to_a.each do |specialSlots|
      catch (:invalidCombination) do
        # Always use first slot for multi slot specials before considering the next ones
        throw :invalidCombination if specialSlots.include?("finger2") && !specialSlots.include?("finger1")
        throw :invalidCombination if specialSlots.include?("trinket2") && !specialSlots.include?("trinket1")
        (2..6).each do |azNum|
          prevAzNum = azNum - 1
          prevAzNum = "" if prevAzNum == 1
          throw :invalidCombination if specialSlots.include?("azerite#{azNum}") && !specialSlots.include?("azerite#{prevAzNum}")
        end
        throw :invalidCombination if specialSlots.include?("essenceMinor") && !specialSlots.include?("essenceMajor")
        throw :invalidCombination if specialSlots.include?("essenceMinor2") && !specialSlots.include?("essenceMinor")

        # Create matching set combination
        usedSlots = [] + specialSlots
        setStrings = []
        setup["sets"].each do |set|
          availableSlots = gear["sets"][set["set"]].keys - usedSlots
          throw :invalidCombination if availableSlots.length < set["pieces"]
          availableSlots.take(set["pieces"]).each do |setSlot|
            setStrings.push("#{setSlot}=#{gear["sets"][set["set"]][setSlot]}")
            usedSlots.push(setSlot)
          end
        end
        setProfileName = setup["sets"].collect { |set| set["pieces"] > 0 ? "#{set["set"]}(#{set["pieces"]})" : "#{set["set"]}" }.join("+")

        # Iterate over special combinations for the current special slot combination
        if specialSlots.empty?
          gearCombinations["#{setProfileName}_None"] = setStrings
          next
        end
        specialCombinations = specialSlots.collect { |specialSlot| gear["specials"][spec][specialSlot].keys }
        specialCombinations = specialCombinations.reduce(&:product) if specialSlots.length > 1 # Create multi-slot cross product
        specialCombinations = specialCombinations.flatten.collect { |x| [x] } if specialSlots.length == 1 # Special handling for only one slot
        specialCombinations = specialCombinations.collect(&:flatten) # Remove inner nested arrays
        specialCombinations = specialCombinations.collect(&:uniq) unless specialSlots.any? { |x| x.include?("azerite") } # No double elements unless azerite combination
        if specialSlots.any? { |x| x.include?("essence") }
          specialCombinations = specialCombinations.uniq { |x| [x[0]] + x[1..-1].sort } # Only unique minor combinations for essences
        else
          specialCombinations = specialCombinations.uniq { |x| x.sort } # Only generally unique combinations
        end
        specialCombinations = specialCombinations.select { |x| x.length == numSpecials } # Only desired amount of specials
        specialCombinations.each do |specialCombination|
          # Special for Azerite: Reject combinations that have more than 3 of the same azerite power
          next if specialSlots.any?("azerite") && gear["specials"][spec]["azerite"].keys.collect { |x| specialCombination.count(x) }.any? { |x| x > 3 }
          # Special for Essences: Get essence ID and ensure they are unique (for Worldvein Allies special case)
          next if specialCombination.collect { |x| essenceList.find { |y| y["name"] == x }&.dig("essenceId") || x }.uniq.count != specialCombination.count

          specialProfileName = specialCombination.join("_")
          specialStrings = []
          specialAzeritePowers = []
          specialEssences = []
          specialCombination.each_with_index do |itemName, idx|
            specialOverrides = ProfileHelper.GetSpecialOverrides("Combinator/#{classfolder}/SpecialOverrides/#{profile}", itemName)
            specialOverrides.each do |specialOverride|
              specialStrings.push(specialOverride)
            end
            # Special treatment for handling Azerite overrides as specials, also replace !!ILVL!! with fitting ilevel
            if specialSlots[idx].include? "azerite"
              specialAzeritePowers.push(gear["specials"][spec][specialSlots[idx]][itemName].gsub("!!ILVL!!", stackPowerLevel.to_s))
            elsif specialSlots[idx].include? "essence"
              specialEssences.push(gear["specials"][spec][specialSlots[idx]][itemName])
              # Handle additional essence input
              if essence = essenceList.find { |x| x["name"] == itemName }
                specialStrings += essence["additionalInput"]
              end
            else
              specialStrings.push("#{specialSlots[idx]}=#{gear["specials"][spec][specialSlots[idx]][itemName]}")
            end
          end
          unless specialAzeritePowers.empty?
            hasAnyAzerite = true
            specialStrings.push("azerite_override=#{specialAzeritePowers.join("/")}")
          end
          unless specialEssences.empty?
            hasAnyEssences = true
            specialStrings.push("azerite_essences=#{specialEssences.join("/")}")
          end
          gearCombinations["#{setProfileName}_#{specialProfileName}"] = specialStrings + setStrings
        end
      end
    end
  end
end

# Combine gear with talents and write simc input to file
simcInput = []
simcInput.push "name=Template"
simcInput.push "disable_azerite=items" if hasAnyAzerite
simcInput.push "azerite_essences=" if hasAnyEssences
simcInput.push ""

Logging.LogScriptInfo "Generating combinations..."
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

# Special naming extension for Azerite stack sims
combinatorStyle = ""
if setupsProfile == "Azerite"
  combinatorStyle = "-#{gearProfile[-2..-1]}"
elsif setupsProfile == "NoAzerite"
  combinatorStyle = "-0A"
elsif ["1E", "2E", "3E"].include? setupsProfile
  combinatorStyle = "-#{setupsProfile}"
end

simulationFilename = "Combinator#{combinatorStyle}_#{fightstyle}_#{profile}"
params = [
  "#{SimcConfig["ConfigFolder"]}/SimcCombinatorConfig.simc",
  fightstyleFile,
  profileFile,
  simcInput,
]
SimcHelper.RunSimulation(params, simulationFilename)

# Read JSON Output
results = JSONResults.new(simulationFilename)

# Process results
Logging.LogScriptInfo "Processing results..."
sims = results.getAllDPSResults()
sims.delete("Template")
priorityDps = results.getPriorityDPSResults()

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = []
sims.each do |name, value|
  actor = []
  # Split profile name (mostly for web display)
  if data = name.match(/\A(\d+)_([^_]+)_?([^;]*)\Z/)
    # Talents
    actor.push(data[1])
    # Tiers
    actor.push(data[2].gsub("+", " + "))
    # Legendaries
    if not data[3].empty?
      legos = data[3].gsub(/_/, "; ")
    else
      legos = "None"
    end
    actor.push(legos)
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
report.sort! { |x, y| y[3] <=> x[3] }
# Add the initial rank
report.each_with_index { |actor, index|
  actor.unshift(index + 1)
}

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

puts
Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
