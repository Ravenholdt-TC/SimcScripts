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

# relic/trinket header
header = []

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
      end
    end
  end
elsif compositeType == "RelicSimulation"
  fightList.each do |fightStyle, weight|
    Logging.LogScriptInfo "Model #{fightStyle} : #{weight}"
    
    reportIndex = 0
    
    jsonList[fightStyle].each do |reportData|
      if reportIndex > 0 # Skip header
        traitIndex = 0
        traitName = ""
        traitDps = 0
        
        reportData.each do |traitData|
          if traitIndex > 0 
            if traitIndex%2 == 0
              if traitDps == 0
                next
              end
              if compositeData[traitName].nil? 
                compositeData[traitName] = {}
              end
              if compositeData[traitName][traitData].nil? 
                compositeData[traitName][traitData] = (weight * traitDps.to_f).round(0)
              else
                compositeData[traitName][traitData] = compositeData[traitName][traitData] + (weight * traitDps.to_f).round(0)
              end
            else
              traitDps = traitData
            end
          else
            traitName = traitData
          end
          traitIndex = traitIndex + 1 
        end
      else #save header
        header = reportData
      end
      reportIndex = reportIndex + 1
    end
  end
elsif compositeType == "TrinketSimulation"

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
  # compositeData.each do |key,actor|
    # actor.each do |key2,actor2|
      # puts "#{key} #{key2} #{actor2}"
    # end
  # end
  # Calculates max column
  maxColumns = 1
  compositeData.each do |name, values|
    maxColumns = values.length if values.length > maxColumns
  end
  
  # Put the header first
  report.push(header)
  
  # Put all data in order
  compositeData.each do |name, values|
    actor = [ ]
    actor.push(name)
    values.sort.each do |rank, dps|
      actor.push(dps)
      actor.push(rank.to_s)
    end
    ((values.length + 1)..maxColumns).each do |i|
      actor.push(0)
      actor.push("")
    end
    report.push(actor)
  end
elsif compositeType == "TrinketSimulation"
end 

# Output to JSON
JSONParser.WriteFile(reportFile, report)

puts
Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
