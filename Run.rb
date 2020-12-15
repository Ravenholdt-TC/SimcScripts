require "rubygems"
require "bundler/setup"
require "optparse"
require_relative "lib/SimcConfig"

to_run = {
  "RaceSimulation" => { ### !!! This will also be used for Consumable, Legendary, and Soulbind simulations
    "Death-Knight" => [
      "T26_Death_Knight_Blood",
      "T26_Death_Knight_Frost",
      "T26_Death_Knight_Unholy",
    ],
    "Demon-Hunter" => [
      "T26_Demon_Hunter_Havoc",
      "T26_Demon_Hunter_Havoc_Momentum",
      "T26_Demon_Hunter_Vengeance",
    ],
    "Druid" => [
      "T26_Druid_Balance",
      "T26_Druid_Feral",
      "T26_Druid_Guardian",
    ],
    "Hunter" => [
      "T26_Hunter_Beast_Mastery",
      "T26_Hunter_Marksmanship",
      "T26_Hunter_Survival",
    ],
    "Mage" => [
      "T26_Mage_Arcane",
      "T26_Mage_Fire",
      "T26_Mage_Frost",
    ],
    "Monk" => [
      "T26_Monk_Brewmaster",
      "T26_Monk_Windwalker",
      "T26_Monk_Windwalker_Serenity",
    ],
    "Paladin" => [
      "T26_Paladin_Protection",
      "T26_Paladin_Retribution",
    ],
    "Priest" => [
      "T26_Priest_Shadow",
    ],
    "Rogue" => [
      "T26_Rogue_Assassination",
      "T26_Rogue_Outlaw",
      "T26_Rogue_Subtlety",
    ],
    "Shaman" => [
      "T26_Shaman_Elemental",
      "T26_Shaman_Enhancement",
      "T26_Shaman_Enhancement_VDW",
    ],
    "Warlock" => [
      "T26_Warlock_Affliction",
      "T26_Warlock_Demonology",
      "T26_Warlock_Destruction",
    ],
    "Warrior" => [
      "T26_Warrior_Arms",
      "T26_Warrior_Fury",
      "T26_Warrior_Protection",
    ],
  },
  "Combinator" => {
    ##############################################################################################
    # Keep the part called !!SetSL!!, this will be auto replaced with different gear and setups. #
    ##############################################################################################
    "Death-Knight" => [
      "T26_Death_Knight_Blood !!SetSL!! xxx20xx",
      "T26_Death_Knight_Frost !!SetSL!! xx0x0xx",
      "T26_Death_Knight_Unholy !!SetSL!! xx0x0xx",
    ],
    "Demon-Hunter" => [
      "T26_Demon_Hunter_Havoc !!SetSL!! xxx0x2[13]",
      "T26_Demon_Hunter_Havoc_Momentum !!SetSL!! xxx0x22",
      "T26_Demon_Hunter_Vengeance !!SetSL!! xxxx1x1",
    ],
    "Druid" => [
      "T26_Druid_Balance !!SetSL!! x000xxx",
      "T26_Druid_Feral !!SetSL!! x000xxx",
      "T26_Druid_Guardian !!SetSL!! x111x2x",
    ],
    "Hunter" => [
      "T26_Hunter_Beast_Mastery !!SetSL!! xx0x0xx",
      "T26_Hunter_Marksmanship !!SetSL!! xx0x0xx",
      "T26_Hunter_Survival !!SetSL!! xx0x0xx",
    ],
    "Mage" => [
      "T26_Mage_Arcane !!SetSL!! x0xx0xx",
      "T26_Mage_Fire !!SetSL!! x0xx0xx",
      "T26_Mage_Frost !!SetSL!! x0xx0xx",
    ],
    "Monk" => [
      "T26_Monk_Brewmaster !!SetSL!! x0x01xx",
      "T26_Monk_Windwalker !!SetSL!! x0x20x[12]",
      "T26_Monk_Windwalker_Serenity !!SetSL!! x0x20x3",
    ],
    "Paladin" => [
      "T26_Paladin_Protection !!SetSL!! xx01x3x",
      "T26_Paladin_Retribution !!SetSL!! xx01x0x",
    ],
    "Priest" => [
      "T26_Priest_Shadow !!SetSL!! x0x0xxx",
    ],
    "Rogue" => [
      "T26_Rogue_Assassination !!SetSL!! xxx00xx",
      "T26_Rogue_Outlaw !!SetSL!! x0x00xx",
      "T26_Rogue_Subtlety !!SetSL!! xxx00xx",
    ],
    "Shaman" => [
      "T26_Shaman_Elemental !!SetSL!! xx0x0xx",
      "T26_Shaman_Enhancement !!SetSL!! xx0x0xx",
      "T26_Shaman_Enhancement_VDW !!SetSL!! xx0x0xx",
    ],
    "Warlock" => [
      "T26_Warlock_Affliction !!SetSL!! xx0x0xx",
      "T26_Warlock_Demonology !!SetSL!! xx0x0xx",
      "T26_Warlock_Destruction !!SetSL!! xx0x0xx",
    ],
    "Warrior" => [
      "T26_Warrior_Arms !!SetSL!! x3x2xxx",
      "T26_Warrior_Fury !!SetSL!! x3x2xxx",
      "T26_Warrior_Protection !!SetSL!! x0x00xx",
    ],
  },
  "TrinketSimulation" => {
    "Death-Knight" => [
      "T26_Death_Knight_Blood Strength",
      "T26_Death_Knight_Frost Strength",
      "T26_Death_Knight_Unholy Strength",
    ],
    "Demon-Hunter" => [
      "T26_Demon_Hunter_Havoc Agility",
      "T26_Demon_Hunter_Havoc_Momentum Agility",
      "T26_Demon_Hunter_Vengeance Agility",
    ],
    "Druid" => [
      "T26_Druid_Balance Intelligence",
      "T26_Druid_Feral Agility",
      "T26_Druid_Guardian Agility",
    ],
    "Hunter" => [
      "T26_Hunter_Beast_Mastery Agility",
      "T26_Hunter_Marksmanship Agility",
      "T26_Hunter_Survival Agility",
    ],
    "Mage" => [
      "T26_Mage_Arcane Intelligence",
      "T26_Mage_Fire Intelligence",
      "T26_Mage_Frost Intelligence",
    ],
    "Monk" => [
      "T26_Monk_Brewmaster Agility",
      "T26_Monk_Windwalker Agility",
      "T26_Monk_Windwalker_Serenity Agility",
    ],
    "Paladin" => [
      "T26_Paladin_Protection Strength",
      "T26_Paladin_Retribution Strength",
    ],
    "Priest" => [
      "T26_Priest_Shadow Intelligence",
    ],
    "Rogue" => [
      "T26_Rogue_Assassination Agility",
      "T26_Rogue_Outlaw Agility",
      "T26_Rogue_Subtlety Agility",
    ],
    "Shaman" => [
      "T26_Shaman_Elemental Intelligence",
      "T26_Shaman_Enhancement Agility",
      "T26_Shaman_Enhancement_VDW Agility",
    ],
    "Warlock" => [
      "T26_Warlock_Affliction Intelligence",
      "T26_Warlock_Demonology Intelligence",
      "T26_Warlock_Destruction Intelligence",
    ],
    "Warrior" => [
      "T26_Warrior_Arms Strength",
      "T26_Warrior_Fury Strength",
      "T26_Warrior_Protection Strength",
    ],
  },
}

# Make links for sims using the same input
to_run["LegendarySimulation"] = to_run["RaceSimulation"]
to_run["SoulbindSimulation"] = to_run["RaceSimulation"]
to_run["ConsumableSimulation"] = to_run["RaceSimulation"]

orders = SimcConfig["RunOrders"]
wow_classes = SimcConfig["RunClasses"]

wow_classes.each do |wow_class|
  orders.each do |steps|
    steps.each do |order|
      scripts = order[0].clone
      fightstyles = order[1].clone
      fightstyles.each do |fightstyle|
        scripts.each do |script|
          next unless to_run[script]
          next unless to_run[script][wow_class]
          commands = to_run[script][wow_class].clone
          commands.each do |command|
            #next if command.start_with?("DS_") && fightstyle != "DS" || !command.start_with?("DS_") && fightstyle == "DS"
            if script == "Combinator" && command.include?("!!SetSL!!")
              # Specified talents for legendaries
              specialCommand = command.gsub("!!SetSL!!", "1L_Generated")
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{specialCommand} q"
              # Default talents for advanced covenant combinations
              specialCommand = command.split("!!SetSL!!")[0] + "FullS_Generated default"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{specialCommand} q"
              specialCommand = command.split("!!SetSL!!")[0] + "EarlyS_Generated default"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{specialCommand} q"
            elsif script == "SoulbindSimulation"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} Kyrian q"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} Necrolord q"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} Night-Fae q"
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} Venthyr q"
            else
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} q"
            end
          end
        end
      end
    end
  end
end

### HAX: For display on HeroDamage, rename our DS reports to include PR so they show as PR fightstyle.
#Dir.glob("#{SimcConfig["ReportsFolder"]}/*_DS_DS_*.{json,csv}").each do |file|
#  puts "Renaming #{file} for PR..."
#  File.rename(file, file.gsub(/_DS_DS_/, "_DS_PR_"))
#end

puts "All batch simulations done! Press enter!"
gets
