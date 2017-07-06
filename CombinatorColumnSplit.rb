lines = []
filebase = ARGV[0].chomp('.csv')
File.open(ARGV[0], 'r') do |file|
  while line = file.gets
    if data = line.match(/\A(\d+)_([^_]+)_?([^,]*),(.*)\Z/)
      if not data[3].empty?
        legos = data[3].gsub(/_/, ', ')
      else
        legos = 'None'
      end
      #fullname = data[0].split(',')[0]
      lines.push("#{data[1]},#{data[2]},\"#{legos}\",#{data[4]}")
    end
  end
end
File.open("#{filebase}_Converted.csv", "w") do |file|
  lines.each { |line| file.puts line }
end
