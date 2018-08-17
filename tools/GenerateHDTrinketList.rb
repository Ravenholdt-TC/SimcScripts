require_relative '../lib/SimcConfig'
require_relative '../lib/JSONParser'

powerList = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeritePower.json")
powerSettings = JSONParser.ReadFile("#{SimcConfig['ProfilesFolder']}/Azerite/AzeriteOptions.json")

allTrinkets = []
files = Dir.glob("#{SimcConfig['ProfilesFolder']}/TrinketLists/[_\-+a-zA-Z0-9]*\.json")
files.sort!
files.each do |file|
  data = JSONParser.ReadFile(file)
  allTrinkets += data['trinkets']
end

JSONParser.WritePrettyFile("#{SimcConfig['HeroDamagePath']}/src/assets/wow-data/TrinketRaw.json", allTrinkets)

puts
puts "Done!"
