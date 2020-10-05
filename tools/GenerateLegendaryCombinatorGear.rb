require_relative "../lib/DataMaps"
require_relative "../lib/JSONParser"

legoList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Legendaries.json")

ClassAndSpecIds.keys.each do |classStr|
  gear = {"specials" => {}, "sets" => {"None" => {}}}
  ClassAndSpecIds[classStr][:specs].each do |specName, specId|
    gear["specials"][specName] = {"shirt" => {}}

    legoList.each do |lego|
      next if !lego["specs"].include?(specId)
      legoName = lego["legendaryName"]
      gear["specials"][specName]["shirt"][legoName] = "sl_legendary,bonus_id=#{lego["legendaryBonusID"]}"
    end
  end
  puts "Writing #{classStr}..."
  JSONParser.WritePrettyFile("#{SimcConfig["ProfilesFolder"]}/Combinator/#{classStr}/CombinatorGear_#{classStr}_Legendaries.json", gear)
end

puts
puts "Done!"
