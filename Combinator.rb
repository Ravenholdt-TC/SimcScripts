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
classfolder = Interactive.SelectSubfolder("Combinator")
covenant = Interactive.SelectFromArray("Covenant", ["Default", "Kyrian", "Necrolord", "Night-Fae", "Venthyr"])
covenant_simc = covenant.downcase.gsub("-", "_")
profile, profileFile = Interactive.SelectTemplate(["Combinator/#{classfolder}/Combinator_", "Templates/#{classfolder}/", ""], classfolder)

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

# Read covenant from template profile
covenant_default = ProfileHelper.GetValueFromTemplate("covenant", profileFile)

gearProfile, gearProfileFile = Interactive.SelectTemplate("Combinator/#{classfolder}/CombinatorGear_")
setupsProfile, setupsProfileFile = Interactive.SelectTemplate("Combinator/CombinatorSetups_")
talentdatasets = Interactive.SelectTalentPermutations(talents)

# Log all interactively set settings
puts
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Fightstyle: #{fightstyle}"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Covenant: #{covenant}"
Logging.LogScriptInfo "-- Profile: #{profile}"
Logging.LogScriptInfo "-- Gear: #{gearProfile}"
Logging.LogScriptInfo "-- Setups: #{setupsProfile}"
Logging.LogScriptInfo "-- Talents: #{talentdatasets}"
puts

# Read gear setups from JSON
gear = JSONParser.ReadFile(gearProfileFile)
setups = JSONParser.ReadFile(setupsProfileFile)

# Duplicate two-slot items
gear["specials"][spec]["finger2"] = gear["specials"][spec]["finger1"]
gear["specials"][spec]["trinket2"] = gear["specials"][spec]["trinket1"]

# Duplicate Conduits for 2 potency slots
gear["specials"][spec]["conduit2"] = gear["specials"][spec]["conduit"]

hasAnyConduits = false

# Import soulbind settings file for conduit rank
conduitList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Conduits.json")
soulbindSettings = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/SoulbindSettings.json")
conduitRank = soulbindSettings["combinatorConduitRank"]

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
        throw :invalidCombination if specialSlots.include?("conduit2") && !specialSlots.include?("conduit")

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
        specialCombinations = specialCombinations.collect(&:uniq)
        specialCombinations = specialCombinations.uniq { |x| x.sort } # Only generally unique combinations
        specialCombinations = specialCombinations.select { |x| x.length == numSpecials } # Only desired amount of specials
        specialCombinations.each do |specialCombination|
          # Special for Conduits: Exclude other covenant conduits if combinator covenant is set
          cov_requirements = specialCombination.collect { |x| soulbindSettings["covenantConduitsMap"][conduitList.find { |y| y["conduitName"] == x }&.dig("conduitSpellID")&.to_s] }
          next if covenant_simc != "default" && cov_requirements.any? { |x| ![covenant_simc, nil].include?(x) }
          next if covenant_simc == "default" && cov_requirements.any? { |x| ![covenant_default, nil].include?(x) }

          specialProfileName = specialCombination.join("_")
          specialStrings = []
          specialConduits = []
          specialCombination.each_with_index do |itemName, idx|
            specialOverrides = ProfileHelper.GetSpecialOverrides("Combinator/#{classfolder}/SpecialOverrides/#{profile}", itemName)
            specialOverrides.each do |specialOverride|
              specialStrings.push(specialOverride)
            end
            # Special treatment for handling Conduit overrides as specials, also replace !!RANK!! with fitting rank
            if specialSlots[idx].include? "conduit"
              specialConduits.push(gear["specials"][spec][specialSlots[idx]][itemName].gsub("!!RANK!!", conduitRank.to_s))
            else
              specialStrings.push("#{specialSlots[idx]}=#{gear["specials"][spec][specialSlots[idx]][itemName]}")
            end
          end
          unless specialConduits.empty?
            hasAnyConduits = true
            specialStrings.push("soulbind=#{specialConduits.join("/")}")
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

if covenant_simc != "default"
  simcInput.push "covenant=" + covenant_simc
end
simcInput.push "soulbind=" if hasAnyConduits || covenant_simc != "default"

if gearProfile.include?("Legendaries") || gearProfile.include?("ShadowlandsFull")
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
if ["1L", "2C", "2CL"].include? setupsProfile
  combinatorStyle = "-#{setupsProfile}"
end

simulationFilename = "Combinator#{combinatorStyle}_#{fightstyle}_#{profile}"
if covenant_simc != "default"
  simulationFilename += "_" + covenant
end
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
