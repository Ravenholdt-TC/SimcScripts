require "rubygems"
require "bundler/setup"
require "optparse"
require_relative "lib/SimcConfig"

to_run = {
  "RaceSimulation" => { ### !!! This will also be used for Consumable, Legendary, and Soulbind simulations
    "Death-Knight" => [
      "T28_Death_Knight_Blood",
      "T28_Death_Knight_Frost",
      "T28_Death_Knight_Unholy",
    ],
    "Demon-Hunter" => [
      "T28_Demon_Hunter_Havoc",
      "T28_Demon_Hunter_Havoc_Momentum",
      "T28_Demon_Hunter_Vengeance",
    ],
    "Druid" => [
      "T28_Druid_Balance",
      "T28_Druid_Feral",
      "T28_Druid_Guardian",
    ],
    "Hunter" => [
      "T28_Hunter_Beast_Mastery",
      "T28_Hunter_Marksmanship",
      "T28_Hunter_Survival",
    ],
    "Mage" => [
      "T28_Mage_Arcane",
      "T28_Mage_Fire",
      "T28_Mage_Frost",
    ],
    "Monk" => [
      "T28_Monk_Brewmaster",
      "T28_Monk_Windwalker",
      "T28_Monk_Windwalker_Serenity",
    ],
    "Paladin" => [
      "T28_Paladin_Protection",
      "T28_Paladin_Retribution",
    ],
    "Priest" => [
      "T28_Priest_Shadow",
    ],
    "Rogue" => [
      "T28_Rogue_Assassination",
      "T28_Rogue_Outlaw",
      "T28_Rogue_Subtlety",
    ],
    "Shaman" => [
      "T28_Shaman_Elemental",
      "T28_Shaman_Enhancement",
      "T28_Shaman_Enhancement_VDW",
    ],
    "Warlock" => [
      "T28_Warlock_Affliction",
      "T28_Warlock_Demonology",
      "T28_Warlock_Destruction",
    ],
    "Warrior" => [
      "T28_Warrior_Arms",
      "T28_Warrior_Fury",
      "T28_Warrior_Protection",
    ],
  },
  "Combinator" => {
    ##############################################################################################
    # Keep the part called !!SetSL!!, this will be auto replaced with different gear and setups. #
    ##############################################################################################
    "Death-Knight" => [
      "T28_Death_Knight_Blood !!SetSL!! xxx20xx",
      "T28_Death_Knight_Frost !!SetSL!! xx0x0xx",
      "T28_Death_Knight_Unholy !!SetSL!! xx0x0xx",
    ],
    "Demon-Hunter" => [
      #"T28_Demon_Hunter_Havoc !!SetSL!! xxx0x2[13]",
      #"T28_Demon_Hunter_Havoc_Momentum !!SetSL!! xxx0x22",
      #"T28_Demon_Hunter_Vengeance !!SetSL!! xxxx1x1",
    ],
    "Druid" => [
      "T28_Druid_Balance !!SetSL!! x000xxx",
      "T28_Druid_Feral !!SetSL!! x000xxx",
      "T28_Druid_Guardian !!SetSL!! x111x2x",
    ],
    "Hunter" => [
      "T28_Hunter_Beast_Mastery !!SetSL!! xx0x0xx",
      "T28_Hunter_Marksmanship !!SetSL!! xx0x0xx",
      "T28_Hunter_Survival !!SetSL!! xx0x0xx",
    ],
    "Mage" => [
      "T28_Mage_Arcane !!SetSL!! x0xx0xx",
      "T28_Mage_Fire !!SetSL!! x0xx0xx",
      "T28_Mage_Frost !!SetSL!! x0xx0xx",
    ],
    "Monk" => [
      "T28_Monk_Brewmaster !!SetSL!! x0x01xx",
      "T28_Monk_Windwalker !!SetSL!! x0x20x[12]",
      "T28_Monk_Windwalker_Serenity !!SetSL!! x0x20x3",
    ],
    "Paladin" => [
      "T28_Paladin_Protection !!SetSL!! xx01x3x",
      "T28_Paladin_Retribution !!SetSL!! xx01x0x",
    ],
    "Priest" => [
      "T28_Priest_Shadow !!SetSL!! x0x0xxx",
    ],
    "Rogue" => [
      "T28_Rogue_Assassination !!SetSL!! xxx00xx",
      "T28_Rogue_Outlaw !!SetSL!! x0x00xx",
      "T28_Rogue_Subtlety !!SetSL!! xxx00xx",
    ],
    "Shaman" => [
      "T28_Shaman_Elemental !!SetSL!! xx0x0xx",
      "T28_Shaman_Enhancement !!SetSL!! xx0x0xx",
      "T28_Shaman_Enhancement_VDW !!SetSL!! xx0x0xx",
    ],
    "Warlock" => [
      "T28_Warlock_Affliction !!SetSL!! xx0x0xx",
      "T28_Warlock_Demonology !!SetSL!! xx0x0xx",
      "T28_Warlock_Destruction !!SetSL!! xx0x0xx",
    ],
    "Warrior" => [
      "T28_Warrior_Arms !!SetSL!! x3x2xxx",
      "T28_Warrior_Fury !!SetSL!! x3x2xxx",
      "T28_Warrior_Protection !!SetSL!! x0x00xx",
    ],
  },
  "TrinketSimulation" => {
    "Death-Knight" => [
      "T28_Death_Knight_Blood Strength",
      "T28_Death_Knight_Frost Strength",
      "T28_Death_Knight_Unholy Strength",
    ],
    "Demon-Hunter" => [
      "T28_Demon_Hunter_Havoc Agility",
      "T28_Demon_Hunter_Havoc_Momentum Agility",
      "T28_Demon_Hunter_Vengeance Agility",
    ],
    "Druid" => [
      "T28_Druid_Balance Intelligence",
      "T28_Druid_Feral Agility",
      "T28_Druid_Guardian Agility",
    ],
    "Hunter" => [
      "T28_Hunter_Beast_Mastery Agility",
      "T28_Hunter_Marksmanship Agility",
      "T28_Hunter_Survival Agility",
    ],
    "Mage" => [
      "T28_Mage_Arcane Intelligence",
      "T28_Mage_Fire Intelligence",
      "T28_Mage_Frost Intelligence",
    ],
    "Monk" => [
      "T28_Monk_Brewmaster Agility",
      "T28_Monk_Windwalker Agility",
      "T28_Monk_Windwalker_Serenity Agility",
    ],
    "Paladin" => [
      #"T28_Paladin_Protection Strength",
      "T28_Paladin_Retribution Strength",
    ],
    "Priest" => [
      "T28_Priest_Shadow Intelligence",
    ],
    "Rogue" => [
      "T28_Rogue_Assassination Agility",
      "T28_Rogue_Outlaw Agility",
      "T28_Rogue_Subtlety Agility",
    ],
    "Shaman" => [
      "T28_Shaman_Elemental Intelligence",
      "T28_Shaman_Enhancement Agility",
      "T28_Shaman_Enhancement_VDW Agility",
    ],
    "Warlock" => [
      "T28_Warlock_Affliction Intelligence",
      "T28_Warlock_Demonology Intelligence",
      "T28_Warlock_Destruction Intelligence",
    ],
    "Warrior" => [
      "T28_Warrior_Arms Strength",
      "T28_Warrior_Fury Strength",
      #"T28_Warrior_Protection Strength",
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
              specialCommand = command.split("!!SetSL!!")[0] + "FullS_Generated default,top"
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
