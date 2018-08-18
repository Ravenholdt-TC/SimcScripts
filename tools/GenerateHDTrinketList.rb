require_relative '../lib/SimcConfig'
require_relative '../lib/JSONParser'

allTrinkets = []
files = Dir.glob("#{SimcConfig['ProfilesFolder']}/TrinketLists/[_\-+a-zA-Z0-9]*\.json")
files.sort!
files.each do |file|
  data = JSONParser.ReadFile(file)
  allTrinkets += data['trinkets']
end

JSONParser.WritePrettyFile("#{SimcConfig['HeroDamagePath']}/src/assets/wow-data/raw/Trinket.json", allTrinkets)

puts
puts "Done!"
