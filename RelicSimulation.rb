require_relative 'SimcConfig'
require_relative 'lib/Interactive'
require_relative 'lib/SimcHelper'

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
            sims[data[1]].merge!(data[2].to_i => dps)
          else
            sims[data[1]] = { data[2].to_i => dps }
          end
        elsif name == 'Template'
          templateDPS = dps
        end
      end
    end
  end

  # Get max number of results (have to fill others for Google Charts to work)
  max_columns = 1
  sims.each do |name, values|
    max_columns = values.length if values.length > max_columns
  end

  # Write to CSV
  File.open(outfile, 'w') do |csv|
    sims.each do |name, values|
      csv.write name
      values.sort.each do |amount, dps|
        dps_inc = dps.to_f - templateDPS.to_f
        csv.write ",#{dps_inc},\"#{amount}\""
      end
      ((values.length + 1)..max_columns).each do |i|
        csv.write ",0,\"\""
      end
      csv.write "\n"
    end
  end
end

template = Interactive.SelectTemplate('RelicSimulation')
fightstyle = Interactive.SelectTemplate('Fightstyle')
logfile = "#{SimcConfig::LogsFolder}/RelicSimulation_#{template}_#{fightstyle}.log"
csvfile = "#{SimcConfig::ReportsFolder}/RelicSimulation_#{template}_#{fightstyle}.csv"
SimcHelper.GenerateSimcConfig()
system "#{SimcConfig::SimcPath}/simc threads=#{SimcConfig::Threads} SimcGlobalConfig.simc SimcRelicConfig.simc " +
  "#{SimcConfig::GeneratedFolder}/GeneratedConfig.simc output=#{logfile} " +
  # "html=#{SimcConfig::ReportsFolder}/RelicSimulation_#{template}_#{fightstyle}.html " +
  "#{SimcConfig::ProfilesFolder}/Fightstyle_#{fightstyle}.simc " +
  "#{SimcConfig::ProfilesFolder}/RelicSimulation_#{template}.simc"
SimcLogToCSV(logfile, csvfile)

puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
