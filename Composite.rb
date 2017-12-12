require 'rubygems'
require 'bundler/setup'
require 'csv'
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
csvFile = "#{SimcConfig['ReportsFolder']}/#{compositeType}_Composite_#{profile}.csv"
Interactive.RemoveFileWithQuestion(csvFile)

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
fightList = {}
lines = 0
buildDate = ""
model['Fightstyle_model'].each do |fight, value|
  # only if fightstyle value is > 0
  unless value != 0
    puts "WARNING: Fightstyle value=0, not using : #{fight} !"
    next
  end

  #check if csv file exists
  reportName = "#{SimcConfig['ReportsFolder']}/#{compositeType}_#{fight}_#{profile}.csv"
  unless File.file?(reportName)
    Logging.LogScriptFatal "ERROR: Report missing : #{reportName} !"
    puts "Press enter to quit..."
    Interactive.GetInputOrArg()
    exit
  end

  #check if meta file exists
  reportNameMeta = "#{SimcConfig['ReportsFolder']}/meta/#{compositeType}_#{fight}_#{profile}.json"
  unless File.file?(reportNameMeta)
    Logging.LogScriptFatal "ERROR: Report meta missing : #{reportNameMeta} !"
    puts "Press enter to quit..."
    Interactive.GetInputOrArg()
    exit
  end

  # check for same build date
  buildDateContent = JSONParser.ReadFile("#{SimcConfig['ReportsFolder']}/meta/#{compositeType}_#{fight}_#{profile}.json")
  if buildDate == ""
    buildDate = buildDateContent['build_date']
  elsif buildDate != buildDateContent['build_date']
    Logging.LogScriptFatal "ERROR: Files don't have the same build date !"
    puts "Press enter to quit..."
    Interactive.GetInputOrArg()
    exit
  end

  # check for same number of lines
  if lines == 0
    lines = CSV.read(reportName).count
  elsif lines != CSV.read(reportName).count
    Logging.LogScriptFatal "ERROR: Files don't have the same length !"
    puts "Press enter to quit..."
    Interactive.GetInputOrArg()
    exit
  end

  # register fight
  fightList[fight] = value
end

# Generate data
puts
Logging.LogScriptInfo "Combining data from csv files..."
compositeData = {}
fightList.each do |fight, value|
  Logging.LogScriptInfo "Model #{fight} : #{value}"

  reportName = "#{SimcConfig['ReportsFolder']}/#{compositeType}_#{fight}_#{profile}.csv"

  #Store everything in the table
  CSV.foreach(reportName) do |row|
    key = row[0] + "," + row[1] + "," + row[2]

    #factor each data with the corresponding value
    if compositeData[key].nil?
      compositeData[key] = (value * row[3].to_f).round(0)
    else
      compositeData[key] = compositeData[key] + (value * row[3].to_f).round(0)
    end
  end
end

# Print data to file
puts
Logging.LogScriptInfo "Writing data in #{csvFile} ..."
File.open(csvFile, 'a') do |csv|
  compositeData.each do |name, value|
    csv.write "#{name},#{value}"
    csv.write "\n"
  end
end

puts
Logging.LogScriptInfo 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
