require_relative 'SimcConfig'
require_relative 'Interactive'

def SimcLogToCSV(infile, outfile)
  puts "Converting #{infile} to #{outfile}..."
  templateDPS = 0
  sims = { }

  # Read results
  File.open(infile, 'r') do |results|
    while line = results.gets
      if line.start_with?('Player:') then
        name = line.split()[1]
        dps = results.gets.split()[1]
        if data = /\A(.+)_(\p{Digit}+)\Z/.match(name) then
          if sims[data[1]] then
            sims[data[1]].merge!(data[2] => dps)
          else
            sims[data[1]] = { data[2] => dps }
          end
        elsif name == 'Template'
          templateDPS = dps
        end
      end
    end
  end

  # Write to CSV
  File.open(outfile, 'w') do |csv|
    sims.each do |name, values|
      csv.write name
      values.sort.each do |ilvl, dps|
        dps_inc = dps.to_f - templateDPS.to_f
        csv.write ",#{dps_inc}"
      end
      csv.write "\n"
    end
  end
end

def CalculateTrinkets()
  template = "#{Template}_" + Interactive.SelectTemplate("#{Template}")
  simcfile = "#{SimcConfig::GeneratedFolder}/#{template}.simc"
  File.open("#{template}.simc", 'r') do |template|
    File.open(simcfile, 'w') do |out|
      while line = template.gets
        out.puts line
      end
      ItemLevels.each do |ilvl|
        TrinketIDs.each do |name, id|
          bonus = ""
          if bid = BonusIDs[name] then
            bonus = ",bonus_id=#{bid}"
          end
          out.puts "copy=#{name}_#{ilvl},Template"
          out.puts "trinket1=,id=#{id},ilevel=#{ilvl}" + bonus
        end
      end
    end
  end
  puts "Simulation profile for #{template} generated!"

  logfile = "#{SimcConfig::LogsFolder}/#{template}.log"
  csvfile = "#{SimcConfig::ReportsFolder}/#{template}.csv"
  system "#{SimcConfig::SimcPath}/simc threads=#{SimcConfig::Threads} SimcGlobalConfig.simc SimcTrinketConfig.simc "+
    "output=#{logfile} html=#{SimcConfig::ReportsFolder}/#{template}.html " + simcfile
  SimcLogToCSV(logfile, csvfile)

  puts 'Done! Press enter to quit...'
  gets
end
