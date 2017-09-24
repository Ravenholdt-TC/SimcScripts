require_relative '../SimcConfig'
require_relative 'Interactive'
require_relative 'JSONParser'
require_relative 'SimcHelper'

def SimcLogToCSV(infile, outfile)
  puts "Converting #{infile} to #{outfile}..."
  templateDPS = 0
  sims = { }

  # Process results
  results = JSONParser.GetAllDPSResults(infile)
  results.each do |name, dps|
    if data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
      if sims[data[1]]
        sims[data[1]].merge!(data[2].to_i => dps)
      else
        sims[data[1]] = { data[2].to_i => dps }
      end
    elsif name == 'Template'
      templateDPS = dps
    end
  end

  # Write to CSV
  File.open(outfile, 'w') do |csv|
    sims.each do |name, values|
      csv.write name
      values.sort.each do |ilvl, dps|
        dps_inc = dps - templateDPS
        csv.write ",#{dps_inc}"
      end
      csv.write "\n"
    end
  end
end

def CalculateTrinkets()
  template = "#{Template}_" + Interactive.SelectTemplate("#{Template}")
  simcfile = "#{SimcConfig::GeneratedFolder}/#{template}.simc"
  File.open("#{SimcConfig::ProfilesFolder}/#{template}.simc", 'r') do |template|
    File.open(simcfile, 'w') do |out|
      while line = template.gets
        out.puts line
      end
      ItemLevels.each do |ilvl|
        TrinketIDs.each do |name, id|
          bonus = ""
          if bid = BonusIDs[name]
            bonus = ",bonus_id=#{bid}"
          end
          out.puts "profileset.#{name}_#{ilvl}=trinket1=,id=#{id},ilevel=#{ilvl}" + bonus
        end
      end
    end
  end
  puts "Simulation profile for #{template} generated!"

  fightstyle = Interactive.SelectTemplate('Fightstyle')
  logfile = "#{SimcConfig::LogsFolder}/#{template}_#{fightstyle}"
  csvfile = "#{SimcConfig::ReportsFolder}/#{template}_#{fightstyle}.csv"
  params = [
    'SimcTrinketConfig.simc',
    "output=#{logfile}.log",
    "json2=#{logfile}.json",
    "#{SimcConfig::ProfilesFolder}/Fightstyle_#{fightstyle}.simc",
    simcfile
  ]
  SimcHelper.RunSimulation(params)
  SimcLogToCSV("#{logfile}.json", csvfile)

  puts 'Done! Press enter to quit...'
  Interactive.GetInputOrArg()
end
