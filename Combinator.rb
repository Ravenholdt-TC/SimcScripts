require_relative 'SimcConfig'
require_relative 'lib/Interactive'

def SimcLogToCSV(infile, outfile)
  puts "Adding data from #{infile} to #{outfile}..."
  sims = { }

  # Read results
  File.open(infile, 'r') do |results|
    while line = results.gets
      if line.start_with?('Player:') then
        name = line.split()[1]
        dps = results.gets.split()[1]
        sims[name] = dps
      end
    end
  end

  # Write to CSV
  File.open(outfile, 'a') do |csv|
    sims.each do |name, value|
      csv.write "#{name},#{value}"
      csv.write "\n"
    end
  end
end

profile = Interactive.SelectTemplate('Combinator')
talentdata = Interactive.SelectTalentPermutations()

# Recreate or append to csv?
csvfile = "#{SimcConfig::ReportsFolder}/Combinator_#{profile}.csv"
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
              logfile = "#{SimcConfig::LogsFolder}/Combinator_#{profile}_#{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7}.log"
              system "#{SimcConfig::SimcPath}/simc threads=#{SimcConfig::Threads} SimcGlobalConfig.simc SimcCombinatorConfig.simc " +
                "output=#{logfile} " +
                "$(tbuild)=#{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7} #{SimcConfig::ProfilesFolder}/Combinator_#{profile}.simc"
              SimcLogToCSV(logfile, csvfile)
            end
          end
        end
      end
    end
  end
end
puts
puts 'Done! Press enter to quit...'
gets
