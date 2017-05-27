def SimcLogToCSV(infile, outfile)
  puts "Converting #{infile} to CSV..."
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

File.delete('Combinator.csv') if File.exist?('Combinator.csv')
(1..3).each do |t1|
  (1..3).each do |t2|
    (1..3).each do |t3|
      (1..3).each do |t6|
        (1..3).each do |t7|
          system "cd .. && simc $(tbuild)=#{t1}#{t2}#{t3}00#{t6}#{t7} scripts/Combinator.simc"
          SimcLogToCSV('Combinator.log', 'Combinator.csv')
        end
      end
    end
  end
end
puts 'Done! Press enter to quit...'
gets
