require_relative 'SimcConfig'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/SimcHelper'

profile = Interactive.SelectTemplate('Combinator')
fightstyle = Interactive.SelectTemplate('Fightstyle')
talentdata = Interactive.SelectTalentPermutations()

# Recreate or append to csv?
csvfile = "#{SimcConfig::ReportsFolder}/Combinator_#{profile}_#{fightstyle}.csv"
Interactive.RemoveFileWithQuestion(csvfile)

puts 'Starting simulations, this may take a while!'
talentdata[0].each do |t1|
  talentdata[1].each do |t2|
    talentdata[2].each do |t3|
      talentdata[3].each do |t4|
        talentdata[4].each do |t5|
          talentdata[5].each do |t6|
            talentdata[6].each do |t7|
              puts "Simulating talent string #{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7}..."
              logfile = "#{SimcConfig::LogsFolder}/Combinator_#{profile}_#{fightstyle}_#{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7}"
              params = [
                'SimcCombinatorConfig.simc',
                "output=#{logfile}.log",
                "json2=#{logfile}.json",
                "$(tbuild)=#{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7}",
                "#{SimcConfig::ProfilesFolder}/Fightstyle_#{fightstyle}.simc",
                "#{SimcConfig::ProfilesFolder}/Combinator_#{profile}.simc"
              ]
              SimcHelper.RunSimulation(params)

              # Write to CSV
              puts "Adding data from #{logfile}.json to #{csvfile}..."
              sims = JSONParser.GetAllDPSResults("#{logfile}.json")
              File.open(csvfile, 'a') do |csv|
                sims.each do |name, value|
                  csv.write "#{name},#{value}"
                  csv.write "\n"
                end
              end
            end
          end
        end
      end
    end
  end
end
puts
puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
