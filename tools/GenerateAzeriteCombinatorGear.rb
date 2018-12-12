require_relative "../lib/DataMaps"
require_relative "../lib/JSONParser"

powerList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/AzeritePower.json")
powerSettings = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/AzeriteOptions.json")

(1..3).each do |azeriteStacks|
  ClassAndSpecIds.keys.each do |classStr|
    gear = {"specials" => {}, "sets" => {"None" => {}}}
    ClassAndSpecIds[classStr][:specs].each do |specName, specId|
      gear["specials"][specName] = {"azerite" => {}}

      # Special Hacky Powerlist Prefiltering in case we have duplicates. Should prolly be fixed elsewhere but do it as failsafe.
      # Write all processed power Names to this array, skip if we already ran it.
      processedPowers = []

      powerList.each do |power|
        next if !power["classesId"].include?(ClassAndSpecIds[classStr][:class_id])
        next if !powerSettings["genericCombinatorPowers"].include?(power["powerId"]) && (!power["specsId"] || !power["specsId"].include?(specId))
        next if powerSettings["blacklistedTiers"].include?(power["tier"])
        next if powerSettings["blacklistedPowers"].include?(power["powerId"])

        powerName = power["spellName"]
        next if processedPowers.include?(powerName)
        processedPowers.push(powerName)

        gear["specials"][specName]["azerite"][powerName] = (["#{power["powerId"]}:!!ILVL!!"] * azeriteStacks).join("/")
      end
    end
    puts "Writing #{classStr}..."
    JSONParser.WritePrettyFile("#{SimcConfig["ProfilesFolder"]}/Combinator/#{classStr}/CombinatorGear_#{classStr}_#{azeriteStacks}A.json", gear)
  end
end

puts
puts "Done!"
