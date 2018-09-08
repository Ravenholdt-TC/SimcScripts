require_relative '../lib/DataMaps'
require_relative '../lib/JSONParser'

powerList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeritePower.json")
powerSettings = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeriteOptions.json")

(1..3).each do |azeriteStacks|
  ClassAndSpecIds.keys.each do |classStr|
    gear = {'specials' => {}, 'sets' => {'None' => {}}}
    ClassAndSpecIds[classStr][:specs].each do |specName, specId|
      gear['specials'][specName] = {'azerite' => {}}
      powerList.each do |power|
        next if !power['classesId'].include?(ClassAndSpecIds[classStr][:class_id])
        next if !power['specsId'] || !power['specsId'].include?(specId)
        next if powerSettings['blacklistedTiers'].include?(power['tier'])
        next if powerSettings['blacklistedPowerIds'].include?(power['powerId'])
        gear['specials'][specName]['azerite'][power['spellName']] = (["#{power['powerId']}:!!ILVL!!"] * azeriteStacks).join('/')
      end
    end
    puts "Writing #{classStr}..."
    JSONParser.WritePrettyFile("#{SimcConfig['ProfilesFolder']}/Combinator/#{classStr}/CombinatorGear_#{classStr}_#{azeriteStacks}A.json", gear)
  end
end

puts
puts "Done!"
