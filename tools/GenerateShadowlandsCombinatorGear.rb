require_relative "../lib/DataMaps"
require_relative "../lib/JSONParser"

legoList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Legendaries.json")
conduitList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Conduits.json")

ClassAndSpecIds.keys.each do |classStr|
  legoGear = {"specials" => {}, "sets" => {"None" => {}}}
  conduitGear = {"specials" => {}, "sets" => {"None" => {}}}
  fullGear = {"specials" => {}, "sets" => {"None" => {}}}

  covenants = {"specials" => {}, "sets" => {"None" => {}}}

  ClassAndSpecIds[classStr][:specs].each do |specName, specId|
    legoGear["specials"][specName] = {"shirt" => {}}
    legoList.each do |lego|
      next if !lego["specs"].include?(specId)
      legoName = lego["legendaryName"]
      legoGear["specials"][specName]["shirt"][legoName] = "sl_legendary,bonus_id=#{lego["legendaryBonusID"]}"
    end
    fullGear["specials"][specName] = legoGear["specials"][specName].clone

    conduitGear["specials"][specName] = {"conduit" => {}}
    conduitList.each do |conduit|
      next if !conduit["specs"].include?(specId)
      next if conduit["conduitType"] != 1

      itemName = conduit["conduitName"]
      conduitGear["specials"][specName]["conduit"][itemName] = "#{conduit["conduitId"]}:!!RANK!!"
    end
    fullGear["specials"][specName].merge!(conduitGear["specials"][specName])

    covenants["specials"][specName] = {"covenant" => {
      "Kyrian" => "kyrian",
      "Necrolord" => "necrolord",
      "Night Fae" => "night_fae",
      "Venthyr" => "venthyr",
    }}
  end
  puts "Writing Legendaries for #{classStr}..."
  JSONParser.WritePrettyFile("#{SimcConfig["ProfilesFolder"]}/Combinator/#{classStr}/CombinatorGear_#{classStr}_Legendaries.json", legoGear)
  puts "Writing Conduits for #{classStr}..."
  JSONParser.WritePrettyFile("#{SimcConfig["ProfilesFolder"]}/Combinator/#{classStr}/CombinatorGear_#{classStr}_Conduits.json", conduitGear)
  puts "Writing Full gear for #{classStr}..."
  JSONParser.WritePrettyFile("#{SimcConfig["ProfilesFolder"]}/Combinator/#{classStr}/CombinatorGear_#{classStr}_ShadowlandsFull.json", fullGear)
  puts "Writing Covenants for #{classStr}..."
  JSONParser.WritePrettyFile("#{SimcConfig["ProfilesFolder"]}/Combinator/#{classStr}/CombinatorGear_#{classStr}_Covenants.json", covenants)
end

puts
puts "Done!"
