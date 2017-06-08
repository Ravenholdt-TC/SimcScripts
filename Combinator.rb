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

# Select Combinator template profile
puts 'Please choose the Combinator profile you want to simulate:'
profiles = {}
index = 1
Dir.glob('Combinator_[a-zA-Z]*\.simc').each do |combfile|
  if profile = combfile.match(/Combinator_([a-zA-Z]*)\.simc/)
    profiles[index] = profile[1]
    puts "#{index}: #{profile[1]}"
    index += 1
  end
end
print 'Profile: '
index = gets.to_i
unless profiles.has_key?(index)
  puts 'ERROR: Invalid profile index entered!'
  puts 'Press enter to quit...'
  gets
  exit
end
puts

# Select talents for permutation
puts 'Please select the talents for permutation:'
puts 'Options: 0-off, 1-left, 2-middle, 3-right, x-Permutation'
puts 'Example: xxx00xx'
print 'Talents: '
talentstring = gets
unless talentstring.match(/\A[0-3xX]{7}\Z/)
  puts 'ERROR: Invalid talent string!'
  puts 'Press enter to quit...'
  gets
  exit
end
talentdata = []
talentstring.chomp.each_char do |tier|
  if tier.downcase.eql? 'x'
    talentdata.push((1..3).to_a)
  else
    talentdata.push([tier.to_i])
  end
end
puts

# Recreate or append to csv?
if File.exist?('Combinator.csv')
  puts 'Do you want to delete the existing Combinator.csv file? If you type "n", results will be appended.'
  print 'Y/n: '
  deletefile = gets
  unless deletefile.chomp.downcase.eql? 'n'
    File.delete('Combinator.csv')
    puts 'Old file deleted!'
  end
  puts
end

puts 'Starting simulations, this may take a while!'
talentdata[0].each do |t1|
  talentdata[1].each do |t2|
    talentdata[2].each do |t3|
      talentdata[3].each do |t4|
        talentdata[4].each do |t5|
          talentdata[5].each do |t6|
            talentdata[6].each do |t7|
              puts "Simulating talent string #{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7}..."
              system "cd .. && simc $(tbuild)=#{t1}#{t2}#{t3}#{t4}#{t5}#{t6}#{t7} scripts/Combinator_#{profiles[index]}.simc"
              SimcLogToCSV('Combinator.log', 'Combinator.csv')
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
