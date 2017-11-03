require 'rubygems'
require 'bundler/setup'
require_relative 'SimcConfig'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/SimcHelper'

profile = Interactive.SelectTemplate('Combinator/Combinator')

#Read spec from profile
spec = ''
File.open("#{SimcConfig::ProfilesFolder}/Combinator/Combinator_#{profile}.simc", 'r') do |pfile|
  while line = pfile.gets
    if line.start_with?('spec=')
      spec = line.chomp.split('=')[1]
    end
  end
end

gearProfile = Interactive.SelectTemplate('Combinator/CombinatorGear')
setupsProfile = Interactive.SelectTemplate('Combinator/CombinatorSetups')
fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')
talentdata = Interactive.SelectTalentPermutations()

# Recreate or append to csv?
csvFile = "#{SimcConfig::ReportsFolder}/Combinator_#{profile}_#{fightstyle}.csv"
Interactive.RemoveFileWithQuestion(csvFile)

# Read gear setups from JSON
gear = JSONParser.ReadFile("#{SimcConfig::ProfilesFolder}/Combinator/CombinatorGear_#{gearProfile}.json")
setups = JSONParser.ReadFile("#{SimcConfig::ProfilesFolder}/Combinator/CombinatorSetups_#{setupsProfile}.json")

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
        setProfileName = setup['sets'].collect {|set| set['pieces'] > 0 ? "#{set['set']}#{set['pieces']}" : "#{set['set']}"}.join('+')

        # Iterate over legendary combinations for the current lego slot combination
        if legoSlots.empty?
          gearCombinations["#{setProfileName}_None"] = setStrings
          next
        end
        legoCombinations = legoSlots.collect {|legoSlot| gear['legendaries'][spec][legoSlot].keys}
        legoCombinations = legoCombinations.reduce(&:product) if legoSlots.length > 1
        legoCombinations = legoCombinations.collect(&:flatten).collect(&:uniq).uniq {|x| x.sort}.select {|x| x.length == numLegos}
        legoCombinations.each do |legoCombination|
          legoProfileName = legoCombination.join('_')
          legoStrings = []
          legoCombination.each_with_index do |itemName, idx|
            legoStrings.push("#{legoSlots[idx]}=#{gear['legendaries'][spec][legoSlots[idx]][itemName]}")
          end
          gearCombinations["#{setProfileName}_#{legoProfileName}"] = legoStrings + setStrings
        end
      end
    end
  end
end

# Combine gear with talents and write simc input to file
simcFile = "#{SimcConfig::GeneratedFolder}/Combinator_#{profile}_#{fightstyle}.simc"
puts "Writing combinations to #{simcFile}!"
File.open(simcFile, 'w') do |out|
  talentdata[0].each do |t1|
    talentdata[1].each do |t2|
      talentdata[2].each do |t3|
        talentdata[3].each do |t4|
          talentdata[4].each do |t5|
            talentdata[5].each do |t6|
              talentdata[6].each do |t7|
                gearCombinations.each do |name, strings|
                  prefix = "profileset.\"#{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7}_#{name}\"+="
                  out.puts(prefix + "talents=#{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7}")
                  strings.each do |string|
                    out.puts(prefix + string)
                  end
                  out.puts
                end
              end
            end
          end
        end
      end
    end
  end
end

puts 'Starting simulations, this may take a while!'
logFile = "#{SimcConfig::LogsFolder}/Combinator_#{profile}_#{fightstyle}"
metaFile = "#{SimcConfig::ReportsFolder}/meta/Combinator_#{profile}_#{fightstyle}.json"
params = [
  "#{SimcConfig::ConfigFolder}/SimcCombinatorConfig.simc",
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  "#{SimcConfig::ProfilesFolder}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig::ProfilesFolder}/Combinator/Combinator_#{profile}.simc",
  simcFile
]
SimcHelper.RunSimulation(params)

# Extract metadata
puts "Extract metadata from #{logFile}.json to #{metaFile}..."
JSONParser.ExtractMetadata("#{logFile}.json", metaFile)

# Write to CSV
puts "Adding data from #{logFile}.json to #{csvFile}..."
sims = JSONParser.GetAllDPSResults("#{logFile}.json")
sims.delete('Template')
File.open(csvFile, 'a') do |csv|
  sims.each do |name, value|
    # Split profile name into nice CSV columns (mostly for web display)
    if data = name.match(/\A(\d+)_([^_]+)_?([^,]*)\Z/)
      if not data[3].empty?
        legos = data[3].gsub(/_/, ', ')
      else
        legos = 'None'
      end
      csv.write "#{data[1]},#{data[2]},\"#{legos}\",#{value}"
    else
      # We should not get here, but leave it as failsafe
      csv.write "#{name},#{value}"
    end
    csv.write "\n"
  end
end

puts
puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
