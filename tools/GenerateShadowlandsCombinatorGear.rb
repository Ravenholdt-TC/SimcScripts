require_relative "../lib/DataMaps"
require_relative "../lib/JSONParser"

SbSettings = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/SoulbindSettings.json")
LegoList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Legendaries.json")
ConduitList = JSONParser.ReadFile("#{SimcConfig["ProfilesFolder"]}/Conduits.json")

templateFull = YAML.load(File.read("#{SimcConfig["ProfilesFolder"]}/Combinator/GearTemplate_FullS.yml"))
templateEarly = YAML.load(File.read("#{SimcConfig["ProfilesFolder"]}/Combinator/GearTemplate_EarlyS.yml"))
template1L = YAML.load(File.read("#{SimcConfig["ProfilesFolder"]}/Combinator/GearTemplate_1L.yml"))

# Insert conduit options
def insertConduits(templateFull, slots)
  slots.each do |sb|
    section = templateFull[sb]["options"]
    conduit_placeholders = section.find_all { |x| x["replace"] == "Conduit" }
    conduit_placeholders.each do |conduit_placeholder|
      section.delete(conduit_placeholder)
      ConduitList.each do |conduit|
        next if conduit["conduitType"] != 1
        next if conduit["specs"].count > 10 #Cheap hack to ignore multiclass conduits

        conduit_entry = {
          "name" => conduit["conduitName"],
          "simcString" => "#{conduit["conduitId"]}:#{SbSettings["combinatorConduitRank"]}",
          "requires" => {},
        }
        if conduit_placeholder["requires"]
          conduit_entry["requires"] = conduit_placeholder["requires"].clone
        end
        if conduit_placeholder["additionalInput"]
          conduit_entry["additionalInput"] = conduit_placeholder["additionalInput"].clone
        end
        requires_covenant = SbSettings["covenantConduitsMap"][conduit["conduitSpellID"].to_s]
        if requires_covenant
          convertMap = {"kyrian" => "Kyrian", "necrolord" => "Necrolord", "night_fae" => "Night Fae", "venthyr" => "Venthyr"}
          conduit_entry["requires"]["covenant"] = convertMap[requires_covenant]
        end
        required_specs = []
        ClassAndSpecIds.keys.each do |classStr|
          ClassAndSpecIds[classStr][:specs].each do |specName, specId|
            if conduit["specs"].include?(specId)
              required_specs.push specName
            end
          end
        end
        conduit_entry["requires"]["spec"] = required_specs
        section.push conduit_entry
      end
    end
  end
end

insertConduits(templateFull, ["soulbind1", "soulbind2", "soulbind3", "soulbind4", "soulbind5", "soulbind6"])
insertConduits(templateEarly, ["soulbind1", "soulbind2", "soulbind3"])

# Add legendaries
# If covenantSplitSlots is not empty then elements in slots that are in covenantSplitSlots will be covenant only
# while all other slots will be spec only.
def insertLegendaries(templateFull, slots, covenantSplitSlots = [])
  slots.each_with_index do |slot, slotIdx|
    templateFull[slot] = {
      "simcSlot" => "shirt",
      "options" => [],
    }
    LegoList.each do |lego|
      next if lego["specs"].count > 10 #Cheap hack to ignore multiclass legendaries
      # Split covenant legos if specified
      if covenantSplitSlots.count > 0
        if lego["covenant"] && !covenantSplitSlots.include?(slot) || !lego["covenant"] && covenantSplitSlots.include?(slot)
          next
        end
      end

      lego_entry = {
        "name" => lego["legendaryName"],
        "simcString" => "sl_legendary,bonus_id=#{lego["legendaryBonusID"]}",
        "requires" => {},
      }
      if slotIdx > 0
        lego_entry["simcString"] = lego["legendaryBonusID"].to_s # Additional slot use id only for combinator concatenation
      end
      required_specs = []
      ClassAndSpecIds.keys.each do |classStr|
        ClassAndSpecIds[classStr][:specs].each do |specName, specId|
          if lego["specs"].include?(specId)
            required_specs.push specName
          end
        end
      end
      lego_entry["requires"]["spec"] = required_specs
      if lego["covenant"]
        lego_entry["requires"]["covenant"] = lego["covenant"].clone
      end
      templateFull[slot]["options"].push lego_entry
    end
  end
end

insertLegendaries(templateFull, ["legendary", "covenantLegendary"], ["covenantLegendary"])
insertLegendaries(templateEarly, ["legendary"])
insertLegendaries(template1L, ["legendary"])

File.open("#{SimcConfig["ProfilesFolder"]}/Combinator/CombinatorGear_FullS_Generated.yml", "w") { |file| file.write(templateFull.to_yaml) }
File.open("#{SimcConfig["ProfilesFolder"]}/Combinator/CombinatorGear_EarlyS_Generated.yml", "w") { |file| file.write(templateEarly.to_yaml) }
File.open("#{SimcConfig["ProfilesFolder"]}/Combinator/CombinatorGear_1L_Generated.yml", "w") { |file| file.write(template1L.to_yaml) }
