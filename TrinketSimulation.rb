# Usage:
#  1. This assumes that your files are placed within a "scripts" folder in
#     the SimulationCraft directory.
#  2. Create a "Template" simulation profile file for your character called
#     "{PROFILE}_Template.simc". (Copy AlareaTrinkets_Template.simc and modify.)
#     Make sure that "trinket1=empty" and "trinket2=empty".
#  3. Create a Ruby file that sets the required constants for this file called
#     "{PROFILE}.rb". (Copy AlareaTrinkets.rb and modify.)
#  4. Run your ruby file, e.g. by double clicking on it.

# Requires constants Template, ItemLevels, TrinketIDs and (optionally) BonusIDs to be set.
# See AlareaTrinkets.rb for an example.

def GenerateSimcProfile()
  File.open("#{Template}_Template.simc", 'r') do |template|
    File.open("#{Template}.simc", 'w') do |out|
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
  puts "Simulation profile for #{Template} generated!"
end

def SimcLogToCSV(infile, outfile)
  puts "Converting #{infile} to CSV..."
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
  GenerateSimcProfile()
  system "cd .. && simc scripts/#{Template}.simc"
  SimcLogToCSV("#{Template}.log", "#{Template}.csv")
  puts 'Done! Press enter to quit...'
  gets
end
