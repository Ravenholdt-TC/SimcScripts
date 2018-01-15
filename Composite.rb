require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/ReportWriter'
require_relative 'lib/SimcConfig'

Logging.Initialize("Composite")

compositeType = Interactive.SelectCompositeType()
classfolder = Interactive.SelectSubfolder('Combinator')
profile = Interactive.SelectTemplate("Combinator/#{classfolder}/Combinator")

# Grab spec
profileInfo = profile.split("_")
setupsProfile = profileInfo.shift
spec = profileInfo.join("_")

# Log all interactively set settings
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Composite Type: #{compositeType}"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Spec: #{spec}"
Logging.LogScriptInfo "-- Profile: #{profile}"
Logging.LogScriptInfo "-- Setups: #{setupsProfile}"

# Read tier model from JSON
model = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Fightstyles/Composite/Composite_#{setupsProfile}.json")

######################
# Check reports integrity
######################
puts
Logging.LogScriptInfo "Verifying all reports needed..."

fightList = {}
reportList = {}
metaList = {}
lines = 0
buildDate = ""

model['Fightstyle_model'].each do |fightStyle, weight|
  Logging.LogScriptInfo "Model #{fightStyle} : #{weight}"

  # only if fightstyle weight is > 0
  unless weight != 0
    Logging.LogScriptFatal "WARNING: Fightstyle weight=0, not using : #{fightStyle} !"
    next
  end

  #check if json file exists
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
  parsedMeta = JSONParser.ReadFile("#{SimcConfig['ReportsFolder']}/meta/#{compositeType}_#{fightStyle}_#{profile}.json")
  if buildDate == ""
    buildDate = parsedMeta['build_date']
  elsif buildDate != parsedMeta['build_date']
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
  reportList[fightStyle] = parsedReport
  metaList[fightStyle] = parsedMeta
end

######################
#### Generate data ###
######################
puts
Logging.LogScriptInfo "Combining data from json files..."

# relic/trinket header
header = []
compositeData = {}
WeaponItemLevelName = 'Weapon Item Level'
PercentageDPSGainName = '% DPS Gain'

if compositeType == "Combinator"
  fightList.each do |fightStyle, weight|
    reportList[fightStyle].each do |reportData|
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
        # Simply add dps values to already stored one
        compositeData[key][3] = compositeData[key][3] + (weight * reportData[4].to_f).round(0)
      end
    end
  end
elsif compositeType == "RelicSimulation"
  fightList.each do |fightStyle, weight|
    reportIndex = 0

    reportList[fightStyle].each do |reportData|
      if reportIndex > 0 # Skip header
        traitIndex = 0
        traitName = ""
        traitDps = 0
        traitLevel = 0

        reportData.each do |traitData|
          if traitIndex > 0
            if traitIndex%2 == 0
              # Stop when we have the last trait
              if traitDps == 0
                next
              end
              if compositeData[traitName].nil?
                compositeData[traitName] = {}
              end
              if traitName == PercentageDPSGainName
                traitLevel = traitData.to_f
              else
                traitLevel = traitData.to_i
              end

              # First iteration, just save
              if compositeData[traitName][traitLevel].nil?
                compositeData[traitName][traitLevel] = (weight * traitDps.to_f).round(0)
              else # Add to already saved result
                compositeData[traitName][traitLevel] = compositeData[traitName][traitLevel] + (weight * traitDps.to_f).round(0)
              end
            else
              # Save trait dps for next iteration
              traitDps = traitData
            end
          else
            # Grab the trait name
            traitName = traitData
          end
          traitIndex = traitIndex + 1
        end
      end
      reportIndex = reportIndex + 1
    end
  end
elsif compositeType == "TrinketSimulation"
  fightList.each do |fightStyle, weight|
    reportIndex = 0

    reportList[fightStyle].each do |reportData|
      if reportIndex > 0 # Skip header
        trinketIndex = 0
        trinketName = ""

        reportData.each do |traitData|
          if trinketIndex > 0
            if compositeData[trinketName].nil?
              compositeData[trinketName] = {}
            end
            # First iteration, just save
            if compositeData[trinketName][trinketIndex-1].nil?
              compositeData[trinketName][trinketIndex-1] = (weight * traitData.to_f).round(0)
            else # Add to already saved result
              compositeData[trinketName][trinketIndex-1] = compositeData[trinketName][trinketIndex-1] + (weight * traitData.to_f).round(0)
            end
          else
            # Grab the trinket name
            trinketName = traitData
          end
          trinketIndex = trinketIndex + 1
        end
      else # save header
        header = reportData
      end
      reportIndex = reportIndex + 1
    end
  end
else
  Logging.LogScriptFatal "ERROR: Composite type not handled yet !"
  puts "Press enter to quit..."
  Interactive.GetInputOrArg()
  exit
end

######################
# Print data to file #
######################
puts
reportFile = "#{SimcConfig['ReportsFolder']}/#{compositeType}_Composite_#{profile}"
Logging.LogScriptInfo "Writing data in #{reportFile}.json ..."

report = []

# Prepare MetaFile
firstFightstyle, firstWeight = fightList.first
metaFile = "#{SimcConfig['ReportsFolder']}/meta/#{compositeType}_#{firstFightstyle}_#{profile}.json"
metaFileComposite = "#{SimcConfig['ReportsFolder']}/meta/#{compositeType}_Composite_#{profile}"
parsedMetaFile = JSONParser.ReadFile(metaFile)

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
  # Recalc cruweight for relicSimultation
  relicList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/RelicSimulation/RelicList.json")
  
  # Calculate Composite Template DPS
  compositeTemplateDps = 0
  fightList.each do |fightStyle, weight|
    compositeTemplateDps = compositeTemplateDps + (weight * metaList[fightStyle]['player']['collected_data']['dps']['mean'].to_f).round(0)
  end
  
  # Calculate cruweight
  if data = /,id=(\p{Digit}+),/.match(relicList['Weapons'][spec])
    Logging.LogScriptInfo 'Generating CrucibleWeight string...'
    weaponId = data[1]
    cruweight = "cruweight^#{weaponId}^ilvl^1^"
    compositeData.each do |name, values|
      next if name == WeaponItemLevelName || name == PercentageDPSGainName
      if trait = relicList['Traits'][spec].find {|trait| trait['name'] == name}
        cruweight += "#{trait['spellId']}^"
        ranks = []
        values.sort.each do |amount, dps|
          if amount - 1 > 0
            weight = dps.to_f / compositeData[WeaponItemLevelName][1].to_f
            ranks.push("#{amount + 4}:#{weight.round(2)}")
          else
            weight = dps.to_f / compositeData[WeaponItemLevelName][1].to_f
            ranks.push("#{weight.round(2)}")
          end
        end
        cruweight += ranks.join(' ') + '^'
      elsif trait = relicList['Traits']['Crucible'].find {|trait| trait['name'] == name}
        weight = values[1].to_f / compositeData[WeaponItemLevelName][1].to_f
        cruweight += "#{trait['spellId']}^#{weight.round(2)}^"
      else
        Logging.LogScriptWarning "WARNING: No spell id for trait #{name} found. Ignoring in crucible weight string."
        next
      end
    end
    cruweight += 'end'
    parsedMetaFile['crucibleweight'] = cruweight
    Logging.LogScriptInfo cruweight
  end

  # Calculates max column
  maxColumns = 1
  compositeData.each do |name, values|
    maxColumns = values.length if values.length > maxColumns
  end

  # Put the header first
  def hashElementType (value)
    return { "type" => value }
  end
  header = [ hashElementType("string") ]
  for i in 1..maxColumns
    header.push(hashElementType("number"))
    header.push(hashElementType("string"))
  end
  report.push(header)

  # Put all data in order
  compositeData.each do |name, values|
    actor = [ ]
    actor.push(name)
    values.each do |rank, dps|
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
  # Put back header
  report.push(header)
  # Trinkets
  compositeData.each do |name, values|
    actor = [ ]
    actor.push(name)
    values.each do |index, dps|
      actor.push(dps)
    end
    report.push(actor)
  end
end

######################
### Output to JSON ###
######################
# Report
ReportWriter.WriteArrayReport(reportFile, report)
# Meta
ReportWriter.WriteArrayReport(metaFileComposite, parsedMetaFile)

Logging.LogScriptInfo "Done! Press enter to quit..."
Interactive.GetInputOrArg()
