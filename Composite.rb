require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/SimcConfig'

Logging.Initialize("Composite")

compositeType = Interactive.SelectCompositeType()
classfolder = Interactive.SelectSubfolder('Combinator')
profile = Interactive.SelectTemplate("Combinator/#{classfolder}/Combinator")

#Read spec from profile
spec = ''
File.open("#{SimcConfig['ProfilesFolder']}/Combinator/#{classfolder}/Combinator_#{profile}.simc", 'r') do |pfile|
  while line = pfile.gets
    if line.start_with?('spec=')
      spec = line.chomp.split('=')[1]
    end
  end
end

setupsProfile = Interactive.SelectTemplate('Combinator/CombinatorSetups')

# Recreate or append to csv?
reportFile = "#{SimcConfig['ReportsFolder']}/#{compositeType}_Composite_#{profile}.json"
Interactive.RemoveFileWithQuestion(reportFile)

# Log all interactively set settings
puts
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Composite Type: #{compositeType}"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Profile: #{profile}"
Logging.LogScriptInfo "-- Setups: #{setupsProfile}"
puts

# Read tier model from JSON
model = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Fightstyles/Composite/Composite_#{setupsProfile}.json")

# Verify reports integrity
Logging.LogScriptInfo "Verifying all reports needed..."
puts
fightList = {}
jsonList = {}
lines = 0
buildDate = ""
model['Fightstyle_model'].each do |fightStyle, weight|
  Logging.LogScriptInfo "Model #{fightStyle} : #{weight}"
  
  # only if fightstyle weight is > 0
  unless weight != 0
    Logging.LogScriptFatal "WARNING: Fightstyle weight=0, not using : #{fightStyle} !"
    next
  end

  #check if csv file exists
  reportName = "#{SimcConfig['ReportsFolder']}/#{compositeType}_#{fightStyle}_#{profile}.json"
  unless File.file?(reportName)
    Logging.LogScriptFatal "ERROR: Report missing : #{reportName} !"
    puts "Press enter to quit..."
    Interactive.GetInputOrArg()
    exit
  end

  #check if meta file exists
  reportNameMeta = "#{SimcConfig['ReportsFolder']}/meta/#{compositeType}_#{fightStyle}_#{profile}.json"
  unless File.file?(reportNameMeta)
    Logging.LogScriptFatal "ERROR: Report meta missing : #{reportNameMeta} !"
    puts "Press enter to quit..."
    Interactive.GetInputOrArg()
    exit
  end

  # check for same build date
  buildDateContent = JSONParser.ReadFile("#{SimcConfig['ReportsFolder']}/meta/#{compositeType}_#{fightStyle}_#{profile}.json")
  if buildDate == ""
    buildDate = buildDateContent['build_date']
  elsif buildDate != buildDateContent['build_date']
    Logging.LogScriptFatal "ERROR: Files don't have the same build date !"
    puts "Press enter to quit..."
    Interactive.GetInputOrArg()
    exit
  end

  # check for same number of lines
  parsedReport = JSONParser.ReadFile(reportName)
  if lines == 0
    lines = parsedReport.count
  elsif lines != parsedReport.count
    Logging.LogScriptFatal "ERROR: Files don't have the same length !"
    puts "Press enter to quit..."
    Interactive.GetInputOrArg()
    exit
  end

  # register fightStyle and store json
  fightList[fightStyle] = weight
  jsonList[fightStyle] = parsedReport
end

# Generate data
puts
Logging.LogScriptInfo "Combining data from json files..."
compositeData = {}

if compositeType == "Combinator"
  fightList.each do |fightStyle, weight|
    Logging.LogScriptInfo "Model #{fightStyle} : #{weight}"

    jsonList[fightStyle].each do |reportData|
      actor = [ ]
      key = "#{reportData[1]} #{reportData[2]} #{reportData[3]}"
      if compositeData[key].nil?
        # Talents
        actor.push(reportData[1])
        # Tiers
        actor.push(reportData[2])
        # Legendaries
        actor.push(reportData[3])
        # DPS value
        actor.push((weight * reportData[4].to_f).round(0))
        
        # Store
        compositeData[key] = actor
      else
        compositeData[key][3] = compositeData[key][3] + (weight * reportData[4].to_f).round(0)
        # puts "#{key} : #{compositeData[key][0]} #{compositeData[key][1]} #{compositeData[key][2]} #{compositeData[key][3]}"
      end
    end
  end
elsif compositeType == "RelicSimulation"
  fightList.each do |fightStyle, weight|
    reportName = "#{SimcConfig['ReportsFolder']}/#{compositeType}_#{fightStyle}_#{profile}.csv"
    
    #Store everything in the table
    CSV.foreach(reportName) do |row|
      key = row[0]
      index = 1
      indexRow = 0
      
      # init table if first file
      # unless compositeData[key].nil?
        # compositeData[key] = []
      # end
      
      until row[index+1].nil?
        puts (index+1)
        puts row[index+1]
        if a[key][(row[index+1]).to_i] == 0
          a[key][(row[index+1]).to_i] = (weight * row[(row[index]).to_i].to_f).round(0) 
        else
          a[key][(row[index+1]).to_i] = a[key][row[(row[index]).to_i]] + (weight * row[(row[index]).to_i].to_f).round(0) 
        end
        index += 2
      end
    end
  end
elsif compositeType == "TrinketSimulation"
  fightList.each do |fightStyle, weight|
    reportName = "#{SimcConfig['ReportsFolder']}/#{compositeType}_#{fightStyle}_#{profile}.csv"
    
    #Store everything in the table
    CSV.foreach(reportName) do |row|
      
    end
  end
else 
  Logging.LogScriptFatal "ERROR: Composite type not handled yet !"
  puts "Press enter to quit..."
  Interactive.GetInputOrArg()
  exit
end

# Print data to file
puts
Logging.LogScriptInfo "Writing data in #{reportFile} ..."

report = []

if compositeType == "Combinator"
  # Rebuild the report
  compositeData.each do |key,actor|
    report.push(actor)
  end
  # Sort the report by the DPS value in DESC order
  report.sort! { |x,y| y[3] <=> x[3] }
  # Add the initial rank
  report.each_with_index { |actor, index|
    actor.unshift(index + 1)
  }
  
elsif compositeType == "RelicSimulation"
  File.open(csvFile, 'a') do |csv|
    a.each do |name, value|

    end
  end
elsif compositeType == "TrinketSimulation"
end 

# Output to JSON
JSONParser.WriteFile(reportFile, report)

puts
Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
