require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/ProfileHelper'
require_relative 'lib/ReportWriter'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

Logging.Initialize("Combinator")

classfolder = Interactive.SelectSubfolder('Combinator')
profile = Interactive.SelectTemplate("Combinator/#{classfolder}/Combinator")

#Read spec from profile
spec = ''
File.open("#{SimcConfig['ProfilesFolder']}/Combinator/#{classfolder}/Combinator_#{profile}.simc", 'r') do |pfile|
  while line = pfile.gets
    if line.start_with?('spec=')
      spec = line.chomp.split('=')[1]
    end
  end
end

gearProfile = Interactive.SelectTemplate("Combinator/#{classfolder}/CombinatorGear")
setupsProfile = Interactive.SelectTemplate('Combinator/CombinatorSetups')
fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')
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
gear = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Combinator/#{classfolder}/CombinatorGear_#{gearProfile}.json")
setups = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Combinator/CombinatorSetups_#{setupsProfile}.json")

# Duplicate two-slot items
gear['legendaries'][spec]['finger2'] = gear['legendaries'][spec]['finger1']
gear['legendaries'][spec]['trinket2'] = gear['legendaries'][spec]['trinket1']

# Build gear combinations
gearCombinations = {}
setups['setups'].each do |setup|
  setup['legendaries'].each do |numLegos|
    # Iterate over legendary slot combinations
    gear['legendaries'][spec].keys.combination(numLegos).to_a.each do |legoSlots|
      catch (:invalidCombination) do
        # Always use first slot for dual slot items before considering the second
        throw :invalidCombination if legoSlots.include?('finger2') && !legoSlots.include?('finger1')
        throw :invalidCombination if legoSlots.include?('trinket2') && !legoSlots.include?('trinket1')

        # Create matching set combination
        usedSlots = [] + legoSlots
        setStrings = []
        setup['sets'].each do |set|
          availableSlots = gear['sets'][set['set']].keys - usedSlots
          throw :invalidCombination if availableSlots.length < set['pieces']
          availableSlots.take(set['pieces']).each do |setSlot|
            setStrings.push("#{setSlot}=#{gear['sets'][set['set']][setSlot]}")
            usedSlots.push(setSlot)
          end
        end
        setProfileName = setup['sets'].collect {|set| set['pieces'] > 0 ? "#{set['set']}(#{set['pieces']})" : "#{set['set']}"}.join('+')

        # Iterate over legendary combinations for the current lego slot combination
        if legoSlots.empty?
          gearCombinations["#{setProfileName}_None"] = setStrings
          next
        end
        legoCombinations = legoSlots.collect {|legoSlot| gear['legendaries'][spec][legoSlot].keys}
        legoCombinations = legoCombinations.reduce(&:product) if legoSlots.length > 1
        legoCombinations = legoCombinations.flatten.collect {|x| [x]} if legoSlots.length == 1
        legoCombinations = legoCombinations.collect(&:flatten).collect(&:uniq).uniq {|x| x.sort}.select {|x| x.length == numLegos}
        legoCombinations.each do |legoCombination|
          legoProfileName = legoCombination.join('_')
          legoStrings = []
          legoCombination.each_with_index do |itemName, idx|
            legoOverrides = ProfileHelper.GetLegendaryOverrides("Combinator/#{classfolder}/LegendaryOverrides/#{profile}", itemName)
            legoOverrides.each do |legoOverride|
              legoStrings.push(legoOverride)
            end
            legoStrings.push("#{legoSlots[idx]}=#{gear['legendaries'][spec][legoSlots[idx]][itemName]}")
          end
          gearCombinations["#{setProfileName}_#{legoProfileName}"] = legoStrings + setStrings
        end
      end
    end
  end
end

# Combine gear with talents and write simc input to file
simcInput = []
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
              gearCombinations.each do |name, strings|
                prefix = "profileset.\"#{talentInput}_#{name}\"+="
                simcInput.push(prefix + "talents=#{talentInput}")
                talentOverrides.each do |talentOverride|
                  simcInput.push(prefix + talentOverride)
                end
                strings.each do |string|
                  simcInput.push(prefix + string)
                end
                simcInput.push ''
              end
            end
          end
        end
      end
    end
  end
end

simulationFilename = "Combinator_#{fightstyle}_#{profile}"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcCombinatorConfig.simc",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/Combinator/#{classfolder}/Combinator_#{profile}.simc",
  simcInput
]
SimcHelper.RunSimulation(params, simulationFilename)

# Read JSON Output
results = JSONResults.new(simulationFilename)

# Process results
Logging.LogScriptInfo "Processing results..."
sims = results.getAllDPSResults()
sims.delete('Template')
priorityDps = results.getPriorityDPSResults()

# Construct the report
Logging.LogScriptInfo "Construct the report..."
report = [ ]
sims.each do |name, value|
  actor = [ ]
  # Split profile name (mostly for web display)
  if data = name.match(/\A(\d+)_([^_]+)_?([^,]*)\Z/)
    # Talents
    actor.push(data[1])
    # Tiers
    actor.push(data[2].gsub('+', ' + '))
    # Legendaries
    if not data[3].empty?
      legos = data[3].gsub(/_/, ', ')
    else
      legos = 'None'
    end
    actor.push(legos)
  else
    # We should not get here, but leave it as failsafe
    actor.push(name)
  end
  actor.push(value) # DPS
  actor.push(priorityDps[name]) if priorityDps[name] # Priority DPS
  report.push(actor)
end
# Sort the report by the DPS value in DESC order
report.sort! { |x,y| y[3] <=> x[3] }
# Add the initial rank
report.each_with_index { |actor, index|
  actor.unshift(index + 1)
}

# Write the report(s)
ReportWriter.WriteArrayReport(results, report)

puts
Logging.LogScriptInfo 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
