require_relative "../lib/DataMaps"
require_relative "../lib/JSONParser"

essenceList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Azerite/Essences.json")

ClassAndSpecIds.keys.each do |classStr|
  gear = {"specials" => {}, "sets" => {"None" => {}}}
  ClassAndSpecIds[classStr][:specs].each do |specName, specId|
    gear["specials"][specName] = {"essenceMajor" => {}, "essenceMinor" => {}}

    essenceList.each do |essence|
      essenceName = essence["name"]
      gear["specials"][specName]["essenceMajor"][essenceName] = "#{essence["essenceId"]}:3:1"
      gear["specials"][specName]["essenceMinor"][essenceName] = "#{essence["essenceId"]}:3:0"
    end
  end
  puts "Writing #{classStr}..."
  JSONParser.WritePrettyFile("#{SimcConfig["ProfilesFolder"]}/Combinator/#{classStr}/CombinatorGear_#{classStr}_Esssences.json", gear)
end

puts
puts "Done!"
