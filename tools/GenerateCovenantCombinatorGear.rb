require_relative "../lib/DataMaps"
require_relative "../lib/JSONParser"

ClassAndSpecIds.keys.each do |classStr|
  gear = {"specials" => {}, "sets" => {"None" => {}}}
  ClassAndSpecIds[classStr][:specs].each do |specName, specId|
    gear["specials"][specName] = {"covenant" => {
      "Kyrian" => "kyrian",
      "Necrolord" => "necrolord",
      "Night Fae" => "night_fae",
      "Venthyr" => "venthyr",
    }}
  end
  puts "Writing #{classStr}..."
  JSONParser.WritePrettyFile("#{SimcConfig["ProfilesFolder"]}/Combinator/#{classStr}/CombinatorGear_#{classStr}_Covenants.json", gear)
end

puts
puts "Done!"
