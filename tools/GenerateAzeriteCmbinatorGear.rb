require_relative '../lib/DataMaps'
require_relative '../lib/JSONParser'

powerList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeritePower.json")
powerSettings = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeriteOptions.json")

generate_at_ilvl = 340

ClassAndSpecIds.keys.each do |classStr|
  gear = {'specials' => {}, 'sets' => {'None' => {}}}
  ClassAndSpecIds[classStr][:specs].each do |specName, specId|
    simcSpecName = specName.downcase.gsub('-', '_')
    gear['specials'][simcSpecName] = {'azerite' => {}}
    powerList.each do |power|
      next if !power['classesId'].include?(ClassAndSpecIds[classStr][:class_id])
      next if !power['specsId'] || !power['specsId'].include?(specId)
      next if powerSettings['blacklistedTiers'].include?(power['tier'])
      next if powerSettings['blacklistedPowerIds'].include?(power['powerId'])
      gear['specials'][simcSpecName]['azerite'][power['spellName']] = "#{power['powerId']}:#{generate_at_ilvl}"
    end
  end
  puts "Writing #{classStr}..."
  JSONParser.WritePrettyFile("#{SimcConfig['ProfilesFolder']}/Combinator/#{classStr}/CombinatorGear_#{classStr}_Azerite.json", gear)
end

puts
puts "Done!"
