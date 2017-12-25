require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/JSONResults'
require_relative 'lib/Logging'
require_relative 'lib/SimcConfig'
require_relative 'lib/SimcHelper'

Logging.Initialize("RelicSimulation")

classfolder = Interactive.SelectSubfolder('RelicSimulation')
template = Interactive.SelectTemplate("RelicSimulation/#{classfolder}/RelicSimulation")

relicList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/RelicSimulation/RelicList.json")
spec = Interactive.SelectFromArray('Specialization', relicList['Weapons'].keys)

fightstyle = Interactive.SelectTemplate('Fightstyles/Fightstyle')

# Log all interactively set settings
puts
Logging.LogScriptInfo "Summarizing input:"
Logging.LogScriptInfo "-- Class: #{classfolder}"
Logging.LogScriptInfo "-- Profile: #{template}"
Logging.LogScriptInfo "-- Specialization: #{spec}"
Logging.LogScriptInfo "-- Fightstyle: #{fightstyle}"
puts

# Generate simc input
simcFile = "#{SimcConfig['GeneratedFolder']}/RelicSimulation_#{fightstyle}_#{template}.simc"
Logging.LogScriptInfo "Writing profilesets to #{simcFile}!"
WeaponItemLevelName = 'Weapon Item Level'
WeaponItemLevelSteps = relicList['Config']['ItemLevelSteps']
File.open(simcFile, 'w') do |out|
  out.puts 'name="Template"'
  out.puts "#{relicList['Weapons'][spec]},ilevel=#{relicList['Config']['BaseItemLevel']}"
  # Reset crucible
  out.puts 'crucible='
  # Override all spec traits to 4
  relicList['Traits'][spec].each do |trait|
    out.puts "artifact_override=#{SimcHelper.TokenizeName(trait['name'])}:4"
  end
  out.puts
  # Weapon Item Level profilesets
  weaponRangeMin = relicList['Config']['BaseItemLevel'] + WeaponItemLevelSteps
  weaponRangeMax = relicList['Config']['BaseItemLevel'] + relicList['Config']['MaximumLevelIncrease']
  (weaponRangeMin..weaponRangeMax).step(WeaponItemLevelSteps) do |ilvl|
    out.puts "profileset.\"#{WeaponItemLevelName}_#{ilvl - relicList['Config']['BaseItemLevel']}\"+=#{relicList['Weapons'][spec]},ilevel=#{ilvl}"
  end
  out.puts
  # Trait profilesets
  (5..7).each.with_index(1) do |rank, amount|
    relicList['Traits'][spec].each do |trait|
      next if trait['exclude']
      next if trait['fightstyleWhitelist'] && !trait['fightstyleWhitelist'].include?(fightstyle)
      next if trait['fightstyleBlacklist'] && trait['fightstyleBlacklist'].include?(fightstyle)
      out.puts "profileset.\"#{trait['name']}_#{amount}\"+=artifact_override=#{SimcHelper.TokenizeName(trait['name'])}:#{rank}"
    end
  end
  out.puts
  (1..3).each do |amount|
    relicList['Traits']['Crucible'].each do |trait|
      next if trait['exclude']
      next if trait['fightstyleWhitelist'] && !trait['fightstyleWhitelist'].include?(fightstyle)
      next if trait['fightstyleBlacklist'] && trait['fightstyleBlacklist'].include?(fightstyle)
      out.puts "profileset.\"#{trait['name']}_#{amount}\"+=artifact_override=#{SimcHelper.TokenizeName(trait['name'])}:#{amount}"
    end
  end
end

Logging.LogScriptInfo 'Starting simulations, this may take a while!'
logFile = "#{SimcConfig['LogsFolder']}/RelicSimulation_#{fightstyle}_#{template}"
reportFile = "#{SimcConfig['ReportsFolder']}/RelicSimulation_#{fightstyle}_#{template}.json"
metaFile = "#{SimcConfig['ReportsFolder']}/meta/RelicSimulation_#{fightstyle}_#{template}.json"
params = [
  "#{SimcConfig['ConfigFolder']}/SimcRelicConfig.simc",
  "output=#{logFile}.log",
  "json2=#{logFile}.json",
  "#{SimcConfig['ProfilesFolder']}/Fightstyles/Fightstyle_#{fightstyle}.simc",
  "#{SimcConfig['ProfilesFolder']}/RelicSimulation/#{classfolder}/RelicSimulation_#{template}.simc",
  simcFile
]
SimcHelper.RunSimulation(params)

# Read JSON Output
results = JSONResults.new("#{logFile}.json")

# Process results
sims = {}
templateDPS = 0
Logging.LogScriptInfo "Converting #{logFile}.json to #{reportFile}..."
results.getAllDPSResults().each do |name, dps|
  if data = /\A(.+)_(\p{Digit}+)\Z/.match(name)
    sims[data[1]] = {} unless sims[data[1]]
    sims[data[1]][data[2].to_i] = dps
  elsif name == 'Template'
    templateDPS = dps
  end
end

# Interpolate between Weapon Item Level Steps
if sims[WeaponItemLevelName]
  sims[WeaponItemLevelName].sort.each do |amount, dps|
    if amount == WeaponItemLevelSteps
      prevStepDPS = templateDPS
    elsif amount % WeaponItemLevelSteps == 0
      prevStepDPS = sims[WeaponItemLevelName][amount - WeaponItemLevelSteps]
    else
      # Not a step value, delete from storage
      sims[WeaponItemLevelName].delete(amount)
      next
    end
    # Write interpolated values
    range_inc = (dps - prevStepDPS) / WeaponItemLevelSteps
    (1..(WeaponItemLevelSteps) - 1).each do |i|
      sims[WeaponItemLevelName].merge!((amount - WeaponItemLevelSteps + i) => (prevStepDPS + i * range_inc))
    end
  end
end

# Get string for crucible weight addon and add it to metadata
addToMeta = {}
if data = /,id=(\p{Digit}+),/.match(relicList['Weapons'][spec])
  Logging.LogScriptInfo 'Generating CrucibleWeight string...'
  weaponId = data[1]
  cruweight = "cruweight^#{weaponId}^ilvl^1^"
  sims.each do |name, values|
    next if name == WeaponItemLevelName
    if trait = relicList['Traits'][spec].find {|trait| trait['name'] == name}
      cruweight += "#{trait['spellId']}^"
      ranks = []
      values.sort.each do |amount, dps|
        if amount - 1 > 0
          weight = (dps.to_f - values[amount - 1]) / (sims[WeaponItemLevelName][1].to_f - templateDPS)
          ranks.push("#{amount + 4}:#{weight.round(2)}")
        else
          weight = (dps.to_f - templateDPS) / (sims[WeaponItemLevelName][1].to_f - templateDPS)
          ranks.push("#{weight.round(2)}")
        end
      end
      cruweight += ranks.join(' ') + '^'
    elsif trait = relicList['Traits']['Crucible'].find {|trait| trait['name'] == name}
      weight = (values[1].to_f - templateDPS) / (sims[WeaponItemLevelName][1].to_f - templateDPS)
      cruweight += "#{trait['spellId']}^#{weight.round(2)}^"
    else
      Logging.LogScriptWarning "WARNING: No spell id for trait #{name} found. Ignoring in crucible weight string."
      next
    end
  end
  cruweight += 'end'
  addToMeta['crucibleweight'] = cruweight
  Logging.LogScriptInfo cruweight
end

# Save metadata
Logging.LogScriptInfo "Extract metadata from #{logFile}.json to #{metaFile}..."
results.extractMetadata(metaFile, addToMeta)

# Get max number of results (have to fill others for Google Charts to work)
max_columns = 1
sims.each do |name, values|
  max_columns = values.length if values.length > max_columns
end

# Write report
report = [ ]
# Header
def hashElementType (value)
  return { "type" => value }
end
header = [ hashElementType("string") ]
for i in 1..max_columns
  header.push(hashElementType("number"))
  header.push(hashElementType("string"))
end
report.push(header)
# Relics
sims.each do |name, values|
  actor = [ ]
  actor.push(name)
  values.sort.each do |rank, dps|
    actor.push(dps - templateDPS)
    actor.push(rank.to_s)
  end
  ((values.length + 1)..max_columns).each do |i|
    actor.push(0)
    actor.push("")
  end
  report.push(actor)
end
# Write into the report file
JSONParser.WriteFile(reportFile, report)

## Should we write plain DT ?
# # Write report (Google Chart DataTable JSON)
# def hashElementType (value)
#   return { "type" => value }
# end
# def hashElementValue (value)
#   return { "v" => value }
# end
# report = { }
# cols = [ hashElementType("string") ]
# for i in 1..max_columns
#   cols.push(hashElementType("number"))
#   cols.push(hashElementType("string"))
# end
# report["cols"] = cols
# rows = [ ]
# sims.each do |name, values|
#   actor = [ ]
#   actor.push(hashElementValue(name))
#   values.sort.each do |rank, dps|
#     actor.push(hashElementValue(dps - templateDPS))
#     actor.push(hashElementValue(rank.to_s))
#   end
#   ((values.length + 1)..max_columns).each do |i|
#     actor.push(hashElementValue(0))
#     actor.push(hashElementValue(""))
#   end
#   rows.push({ "c" => actor })
# end
# report["rows"] = rows
# # Write into the report file
# JSONParser.WriteFile(reportFile, report)

Logging.LogScriptInfo 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
