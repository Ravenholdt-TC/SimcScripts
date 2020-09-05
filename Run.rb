require "rubygems"
require "bundler/setup"
require "optparse"
require_relative "lib/SimcConfig"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [-r]"

  opts.on("-r", "Do the run starting from the end") do |r|
    options[:reverse] = r
  end
end.parse!

to_run = {
  "AzeriteSimulation" => { ### !!! This will also be used for Essence and Race simulations
    "Death-Knight" => [
      "T25_Death_Knight_Blood",
      "T25_Death_Knight_Frost",
      "T25_Death_Knight_Unholy",
      "DS_Death_Knight_Blood",
      "DS_Death_Knight_Frost",
      "DS_Death_Knight_Unholy",
    ],
    "Demon-Hunter" => [
      "T25_Demon_Hunter_Havoc",
      "T25_Demon_Hunter_Havoc_Momentum",
      "T25_Demon_Hunter_Vengeance",
      "DS_Demon_Hunter_Havoc",
      "DS_Demon_Hunter_Havoc_Momentum",
      "DS_Demon_Hunter_Vengeance",
    ],
    "Druid" => [
      "T25_Druid_Balance",
      "T25_Druid_Feral",
      "T25_Druid_Guardian",
      "DS_Druid_Balance",
      "DS_Druid_Feral",
      "DS_Druid_Guardian",
    ],
    "Hunter" => [
      "T25_Hunter_Beast_Mastery",
      "T25_Hunter_Marksmanship",
      "T25_Hunter_Survival",
      "DS_Hunter_Beast_Mastery",
      "DS_Hunter_Marksmanship",
      "DS_Hunter_Survival",
    ],
    "Mage" => [
      "T25_Mage_Arcane",
      "T25_Mage_Fire",
      "T25_Mage_Frost",
      "DS_Mage_Arcane",
      "DS_Mage_Fire",
      "DS_Mage_Frost",
    ],
    "Monk" => [
      "T25_Monk_Brewmaster",
      "T25_Monk_Windwalker",
      "DS_Monk_Brewmaster",
      "DS_Monk_Windwalker",
    ],
    "Paladin" => [
      "T25_Paladin_Protection",
      "T25_Paladin_Retribution",
      "DS_Paladin_Protection",
      "DS_Paladin_Retribution",
    ],
    "Priest" => [
      "T25_Priest_Shadow",
      "DS_Priest_Shadow",
    ],
    "Rogue" => [
      "T25_Rogue_Assassination",
      "T25_Rogue_Outlaw",
      "T25_Rogue_Subtlety",
      "DS_Rogue_Assassination",
      "DS_Rogue_Outlaw",
      "DS_Rogue_Subtlety",
    ],
    "Shaman" => [
      "T25_Shaman_Elemental",
      "T25_Shaman_Enhancement",
      "DS_Shaman_Elemental",
      "DS_Shaman_Enhancement",
    ],
    "Warlock" => [
      "T25_Warlock_Affliction",
      "T25_Warlock_Demonology",
      "T25_Warlock_Destruction",
      "DS_Warlock_Affliction",
      "DS_Warlock_Demonology",
      "DS_Warlock_Destruction",
    ],
    "Warrior" => [
      "T25_Warrior_Arms",
      "T25_Warrior_Fury",
      "T25_Warrior_Protection",
      "DS_Warrior_Arms",
      "DS_Warrior_Fury",
      "DS_Warrior_Protection",
    ],
  },
  "Combinator" => {
    ##########################################################################################
    # Keep the gear called Azerite and setup as well, this will be auto replaced for stacks. #
    ##########################################################################################
    "Death-Knight" => [
      "T25_Death_Knight_Blood Death-Knight_Azerite Azerite xxx20xx",
      "T25_Death_Knight_Frost Death-Knight_Azerite Azerite xx0x0xx",
      "T25_Death_Knight_Unholy Death-Knight_Azerite Azerite xx0x0xx",
      "DS_Death_Knight_Blood Death-Knight_Azerite Azerite xxx20xx",
      "DS_Death_Knight_Frost Death-Knight_Azerite Azerite xx0x0xx",
      "DS_Death_Knight_Unholy Death-Knight_Azerite Azerite xx0x0xx",
      # Essence sims
      "T25_Death_Knight_Blood Death-Knight_Essences 1E xxx20xx",
      "T25_Death_Knight_Frost Death-Knight_Essences 1E xx0x0xx",
      "T25_Death_Knight_Unholy Death-Knight_Essences 1E xx0x0xx",
      "DS_Death_Knight_Blood Death-Knight_Essences 1E xxx20xx",
      "DS_Death_Knight_Frost Death-Knight_Essences 1E xx0x0xx",
      "DS_Death_Knight_Unholy Death-Knight_Essences 1E xx0x0xx",
      "T25_Death_Knight_Blood Death-Knight_Essences ME default",
      "T25_Death_Knight_Frost Death-Knight_Essences ME default",
      "T25_Death_Knight_Unholy Death-Knight_Essences ME default",
      "DS_Death_Knight_Blood Death-Knight_Essences ME default",
      "DS_Death_Knight_Frost Death-Knight_Essences ME default",
      "DS_Death_Knight_Unholy Death-Knight_Essences ME default",
    ],
    "Demon-Hunter" => [
      "T25_Demon_Hunter_Havoc Demon-Hunter_Azerite Azerite xxx0x2[13]",
      "T25_Demon_Hunter_Havoc_Momentum Demon-Hunter_Azerite Azerite xxx0x22",
      "T25_Demon_Hunter_Vengeance Demon-Hunter_Azerite Azerite xxxx1x1",
      "DS_Demon_Hunter_Havoc Demon-Hunter_Azerite Azerite xxx0x2[13]",
      "DS_Demon_Hunter_Havoc_Momentum Demon-Hunter_Azerite Azerite xxx0x22",
      "DS_Demon_Hunter_Vengeance Demon-Hunter_Azerite Azerite xxxx1x1",
      # Essence sims
      "T25_Demon_Hunter_Havoc Demon-Hunter_Essences 1E xxx0x2[13]",
      "T25_Demon_Hunter_Havoc_Momentum Demon-Hunter_Essences 1E xxx0x22",
      "T25_Demon_Hunter_Vengeance Demon-Hunter_Essences 1E xxxx1x1",
      "DS_Demon_Hunter_Havoc Demon-Hunter_Essences 1E xxx0x2[13]",
      "DS_Demon_Hunter_Havoc_Momentum Demon-Hunter_Essences 1E xxx0x22",
      "DS_Demon_Hunter_Vengeance Demon-Hunter_Essences 1E xxxx1x1",
      "T25_Demon_Hunter_Havoc Demon-Hunter_Essences ME default",
      "T25_Demon_Hunter_Havoc_Momentum Demon-Hunter_Essences ME default",
      "T25_Demon_Hunter_Vengeance Demon-Hunter_Essences ME default",
      "DS_Demon_Hunter_Havoc Demon-Hunter_Essences ME default",
      "DS_Demon_Hunter_Havoc_Momentum Demon-Hunter_Essences ME default",
      "DS_Demon_Hunter_Vengeance Demon-Hunter_Essences ME default",
    ],
    "Druid" => [
      "T25_Druid_Balance Druid_Azerite Azerite x000xxx",
      "T25_Druid_Feral Druid_Azerite Azerite x000xxx",
      "T25_Druid_Guardian Druid_Azerite Azerite x111x2x",
      "DS_Druid_Balance Druid_Azerite Azerite x000xxx",
      "DS_Druid_Feral Druid_Azerite Azerite x000xxx",
      "DS_Druid_Guardian Druid_Azerite Azerite x111x2x",
      # Essence sims
      "T25_Druid_Balance Druid_Essences 1E x000xxx",
      "T25_Druid_Feral Druid_Essences 1E x000xxx",
      "T25_Druid_Guardian Druid_Essences 1E x111x2x",
      "DS_Druid_Balance Druid_Essences 1E x000xxx",
      "DS_Druid_Feral Druid_Essences 1E x000xxx",
      "DS_Druid_Guardian Druid_Essences 1E x111x2x",
      "T25_Druid_Balance Druid_Essences ME default",
      "T25_Druid_Feral Druid_Essences ME default",
      "T25_Druid_Guardian Druid_Essences ME default",
      "DS_Druid_Balance Druid_Essences ME default",
      "DS_Druid_Feral Druid_Essences ME default",
      "DS_Druid_Guardian Druid_Essences ME default",
    ],
    "Hunter" => [
      "T25_Hunter_Beast_Mastery Hunter_Azerite Azerite xx0x0xx",
      "T25_Hunter_Marksmanship Hunter_Azerite Azerite xx0x0xx",
      "T25_Hunter_Survival Hunter_Azerite Azerite xx0x0xx",
      "DS_Hunter_Beast_Mastery Hunter_Azerite Azerite xx0x0xx",
      "DS_Hunter_Marksmanship Hunter_Azerite Azerite xx0x0xx",
      "DS_Hunter_Survival Hunter_Azerite Azerite xx0x0xx",
      # Essence sims
      "T25_Hunter_Beast_Mastery Hunter_Essences 1E xx0x0xx",
      "T25_Hunter_Marksmanship Hunter_Essences 1E xx0x0xx",
      "T25_Hunter_Survival Hunter_Essences 1E xx0x0xx",
      "DS_Hunter_Beast_Mastery Hunter_Essences 1E xx0x0xx",
      "DS_Hunter_Marksmanship Hunter_Essences 1E xx0x0xx",
      "DS_Hunter_Survival Hunter_Essences 1E xx0x0xx",
      "T25_Hunter_Beast_Mastery Hunter_Essences ME default",
      "T25_Hunter_Marksmanship Hunter_Essences ME default",
      "T25_Hunter_Survival Hunter_Essences ME default",
      "DS_Hunter_Beast_Mastery Hunter_Essences ME default",
      "DS_Hunter_Marksmanship Hunter_Essences ME default",
      "DS_Hunter_Survival Hunter_Essences ME default",
    ],
    "Mage" => [
      "T25_Mage_Arcane Mage_Azerite Azerite x0xx0xx",
      "T25_Mage_Fire Mage_Azerite Azerite x0xx0xx",
      "T25_Mage_Frost Mage_Azerite Azerite x0xx0xx",
      #"T25_Mage_Frost_NoIceLance Mage_Azerite Azerite x0xx0x3",
      #"T25_Mage_Frost_FrozenOrb Mage_Azerite Azerite x0xx0x[12]",
      "DS_Mage_Arcane Mage_Azerite Azerite x0xx0xx",
      "DS_Mage_Fire Mage_Azerite Azerite x0xx0xx",
      "DS_Mage_Frost Mage_Azerite Azerite x0xx0xx",
      # Essence sims
      "T25_Mage_Arcane Mage_Essences 1E x0xx0xx",
      "T25_Mage_Fire Mage_Essences 1E x0xx0xx",
      "T25_Mage_Frost Mage_Essences 1E x0xx0xx",
      #"T25_Mage_Frost_NoIceLance Mage_Essences 1E x0xx0x3",
      #"T25_Mage_Frost_FrozenOrb Mage_Essences 1E x0xx0x[12]",
      "DS_Mage_Arcane Mage_Essences 1E x0xx0xx",
      "DS_Mage_Fire Mage_Essences 1E x0xx0xx",
      "DS_Mage_Frost Mage_Essences 1E x0xx0xx",
      "T25_Mage_Arcane Mage_Essences ME default",
      "T25_Mage_Fire Mage_Essences ME default",
      "T25_Mage_Frost Mage_Essences ME default",
      #"T25_Mage_Frost_NoIceLance Mage_Essences ME default",
      #"T25_Mage_Frost_FrozenOrb Mage_Essences ME default",
      "DS_Mage_Arcane Mage_Essences ME default",
      "DS_Mage_Fire Mage_Essences ME default",
      "DS_Mage_Frost Mage_Essences ME default",
    ],
    "Monk" => [
      "T25_Monk_Windwalker Monk_Azerite Azerite x0x20xx",
      "DS_Monk_Windwalker Monk_Azerite Azerite x0x20xx",
      # Essence sims
      "T25_Monk_Windwalker Monk_Essences 1E x0x20xx",
      "DS_Monk_Windwalker Monk_Essences 1E x0x20xx",
      "T25_Monk_Windwalker Monk_Essences ME default",
      "DS_Monk_Windwalker Monk_Essences ME default",
    ],
    "Paladin" => [
      "T25_Paladin_Protection Paladin_Azerite Azerite xx0000x",
      "T25_Paladin_Retribution Paladin_Azerite Azerite xx0x00x",
      "DS_Paladin_Protection Paladin_Azerite Azerite xx0000x",
      "DS_Paladin_Retribution Paladin_Azerite Azerite xx0x00x",
      # Essence sims
      "T25_Paladin_Protection Paladin_Essences 1E xx0000x",
      "T25_Paladin_Retribution Paladin_Essences 1E xx0x00x",
      "DS_Paladin_Protection Paladin_Essences 1E xx0000x",
      "DS_Paladin_Retribution Paladin_Essences 1E xx0x00x",
      "T25_Paladin_Protection Paladin_Essences ME default",
      "T25_Paladin_Retribution Paladin_Essences ME default",
      "DS_Paladin_Protection Paladin_Essences ME default",
      "DS_Paladin_Retribution Paladin_Essences ME default",
    ],
    "Priest" => [
      "T25_Priest_Shadow Priest_Azerite Azerite x1x1xxx",
      "DS_Priest_Shadow Priest_Azerite Azerite x1x1xxx",
      # Essence sims
      "T25_Priest_Shadow Priest_Essences 1E x1x1xxx",
      "DS_Priest_Shadow Priest_Essences 1E x1x1xxx",
      "T25_Priest_Shadow Priest_Essences ME default",
      "DS_Priest_Shadow Priest_Essences ME default",
    ],
    "Rogue" => [
      "T25_Rogue_Assassination Rogue_Azerite Azerite xxx00xx",
      "T25_Rogue_Outlaw Rogue_Azerite Azerite x0x00xx",
      "T25_Rogue_Subtlety Rogue_Azerite Azerite xxx00xx",
      "DS_Rogue_Assassination Rogue_Azerite Azerite xxx00xx",
      "DS_Rogue_Outlaw Rogue_Azerite Azerite x0x00xx",
      "DS_Rogue_Subtlety Rogue_Azerite Azerite xxx00xx",
      # Essence sims
      "T25_Rogue_Assassination Rogue_Essences 1E xxx00xx",
      "T25_Rogue_Outlaw Rogue_Essences 1E x0x00xx",
      "T25_Rogue_Subtlety Rogue_Essences 1E xxx00xx",
      "DS_Rogue_Assassination Rogue_Essences 1E xxx00xx",
      "DS_Rogue_Outlaw Rogue_Essences 1E x0x00xx",
      "DS_Rogue_Subtlety Rogue_Essences 1E xxx00xx",
      "T25_Rogue_Assassination Rogue_Essences ME 2[23]10021",
      "T25_Rogue_Outlaw Rogue_Essences ME default",
      "T25_Rogue_Subtlety Rogue_Essences ME 2[13]20031",
      "DS_Rogue_Assassination Rogue_Essences ME default",
      "DS_Rogue_Outlaw Rogue_Essences ME default",
      "DS_Rogue_Subtlety Rogue_Essences ME default",
    ],
    "Shaman" => [
      "T25_Shaman_Elemental Shaman_Azerite Azerite xx0x0xx",
      "T25_Shaman_Enhancement Shaman_Azerite Azerite xx0x0xx",
      "DS_Shaman_Elemental Shaman_Azerite Azerite xx0x0xx",
      "DS_Shaman_Enhancement Shaman_Azerite Azerite xx0x0xx",
      # Essence sims
      "T25_Shaman_Elemental Shaman_Essences 1E xx0x0xx",
      "T25_Shaman_Enhancement Shaman_Essences 1E xx0x0xx",
      "DS_Shaman_Elemental Shaman_Essences 1E xx0x0xx",
      "DS_Shaman_Enhancement Shaman_Essences 1E xx0x0xx",
      "T25_Shaman_Elemental Shaman_Essences ME default",
      "T25_Shaman_Enhancement Shaman_Essences ME default",
      "DS_Shaman_Elemental Shaman_Essences ME default",
      "DS_Shaman_Enhancement Shaman_Essences ME default",
    ],
    "Warlock" => [
      "T25_Warlock_Affliction Warlock_Azerite Azerite xx0x0xx",
      "T25_Warlock_Demonology Warlock_Azerite Azerite xx0x0xx",
      "T25_Warlock_Destruction Warlock_Azerite Azerite xx0x0xx",
      "DS_Warlock_Affliction Warlock_Azerite Azerite xx0x0xx",
      "DS_Warlock_Demonology Warlock_Azerite Azerite xx0x0xx",
      "DS_Warlock_Destruction Warlock_Azerite Azerite xx0x0xx",
      # Essence sims
      "T25_Warlock_Affliction Warlock_Essences 1E xx0x0xx",
      "T25_Warlock_Demonology Warlock_Essences 1E xx0x0xx",
      "T25_Warlock_Destruction Warlock_Essences 1E xx0x0xx",
      "DS_Warlock_Affliction Warlock_Essences 1E xx0x0xx",
      "DS_Warlock_Demonology Warlock_Essences 1E xx0x0xx",
      "DS_Warlock_Destruction Warlock_Essences 1E xx0x0xx",
      "T25_Warlock_Affliction Warlock_Essences ME default",
      "T25_Warlock_Demonology Warlock_Essences ME default",
      "T25_Warlock_Destruction Warlock_Essences ME default",
      "DS_Warlock_Affliction Warlock_Essences ME default",
      "DS_Warlock_Demonology Warlock_Essences ME default",
      "DS_Warlock_Destruction Warlock_Essences ME default",
    ],
    "Warrior" => [
      "T25_Warrior_Arms Warrior_Azerite Azerite x3x2xxx",
      "T25_Warrior_Fury Warrior_Azerite Azerite x3x2xxx",
      "T25_Warrior_Protection Warrior_Azerite Azerite x0x00xx",
      "DS_Warrior_Arms Warrior_Azerite Azerite x3x2xxx",
      "DS_Warrior_Fury Warrior_Azerite Azerite x3x2xxx",
      "DS_Warrior_Protection Warrior_Azerite Azerite x0x00xx",
      # Essence sims
      "T25_Warrior_Arms Warrior_Essences 1E x3x2xxx",
      "T25_Warrior_Fury Warrior_Essences 1E x3x2xxx",
      "T25_Warrior_Protection Warrior_Essences 1E x0x00xx",
      "DS_Warrior_Arms Warrior_Essences 1E x3x2xxx",
      "DS_Warrior_Fury Warrior_Essences 1E x3x2xxx",
      "DS_Warrior_Protection Warrior_Essences 1E x0x00xx",
      "T25_Warrior_Arms Warrior_Essences ME default",
      "T25_Warrior_Fury Warrior_Essences ME default",
      "T25_Warrior_Protection Warrior_Essences ME default",
      "DS_Warrior_Arms Warrior_Essences ME default",
      "DS_Warrior_Fury Warrior_Essences ME default",
      "DS_Warrior_Protection Warrior_Essences ME default",
    ],
  },
  "TrinketSimulation" => {
    "Death-Knight" => [
      "T25_Death_Knight_Blood Strength",
      "T25_Death_Knight_Frost Strength",
      "T25_Death_Knight_Unholy Strength",
      "DS_Death_Knight_Blood Strength",
      "DS_Death_Knight_Frost Strength",
      "DS_Death_Knight_Unholy Strength",
    ],
    "Demon-Hunter" => [
      "T25_Demon_Hunter_Havoc Agility",
      "T25_Demon_Hunter_Havoc_Momentum Agility",
      "T25_Demon_Hunter_Vengeance Agility",
      "DS_Demon_Hunter_Havoc Agility",
      "DS_Demon_Hunter_Havoc_Momentum Agility",
      "DS_Demon_Hunter_Vengeance Agility",
    ],
    "Druid" => [
      "T25_Druid_Balance Intelligence",
      "T25_Druid_Feral Agility",
      "T25_Druid_Guardian Agility",
      "DS_Druid_Balance Intelligence",
      "DS_Druid_Feral Agility",
      "DS_Druid_Guardian Agility",
    ],
    "Hunter" => [
      "T25_Hunter_Beast_Mastery Agility",
      "T25_Hunter_Marksmanship Agility",
      "T25_Hunter_Survival Agility",
      "DS_Hunter_Beast_Mastery Agility",
      "DS_Hunter_Marksmanship Agility",
      "DS_Hunter_Survival Agility",
    ],
    "Mage" => [
      "T25_Mage_Arcane Intelligence",
      "T25_Mage_Fire Intelligence",
      "T25_Mage_Frost Intelligence",
      "DS_Mage_Arcane Intelligence",
      "DS_Mage_Fire Intelligence",
      "DS_Mage_Frost Intelligence",
    ],
    "Monk" => [
      "T25_Monk_Windwalker Agility",
      "T25_Monk_Brewmaster Agility",
      "DS_Monk_Windwalker Agility",
      "DS_Monk_Brewmaster Agility",
    ],
    "Paladin" => [
      "T25_Paladin_Protection Strength",
      "T25_Paladin_Retribution Strength",
      "DS_Paladin_Protection Strength",
      "DS_Paladin_Retribution Strength",
    ],
    "Priest" => [
      "T25_Priest_Shadow Intelligence",
      "DS_Priest_Shadow Intelligence",
    ],
    "Rogue" => [
      "T25_Rogue_Assassination Agility",
      "T25_Rogue_Outlaw Agility",
      "T25_Rogue_Subtlety Agility",
      "DS_Rogue_Assassination Agility",
      "DS_Rogue_Outlaw Agility",
      "DS_Rogue_Subtlety Agility",
    ],
    "Shaman" => [
      "T25_Shaman_Elemental Intelligence",
      "T25_Shaman_Enhancement Agility",
      "DS_Shaman_Elemental Intelligence",
      "DS_Shaman_Enhancement Agility",
    ],
    "Warlock" => [
      "T25_Warlock_Affliction Intelligence",
      "T25_Warlock_Demonology Intelligence",
      "T25_Warlock_Destruction Intelligence",
      "DS_Warlock_Affliction Intelligence",
      "DS_Warlock_Demonology Intelligence",
      "DS_Warlock_Destruction Intelligence",
    ],
    "Warrior" => [
      "T25_Warrior_Arms Strength",
      "T25_Warrior_Fury Strength",
      "T25_Warrior_Protection Strength",
      "DS_Warrior_Arms Strength",
      "DS_Warrior_Fury Strength",
      "DS_Warrior_Protection Strength",
    ],
  },
}

# Make links for sims using the same input
to_run["EssenceSimulation"] = to_run["AzeriteSimulation"]
to_run["RaceSimulation"] = to_run["AzeriteSimulation"]

orders = SimcConfig["RunOrders"]
wow_classes = SimcConfig["RunClasses"]
azeriteStacks = SimcConfig["RunCombinatorAzeriteStacks"]

if options[:reverse]
  wow_classes.reverse!
  azeriteStacks.reverse!
end

orders.each do |steps|
  steps.reverse! if options[:reverse]
  steps.each do |order|
    scripts = order[0].clone
    scripts.reverse! if options[:reverse]
    fightstyles = order[1].clone
    fightstyles.reverse! if options[:reverse]
    scripts.each do |script|
      fightstyles.each do |fightstyle|
        wow_classes.each do |wow_class|
          commands = to_run[script][wow_class].clone
          commands.reverse! if options[:reverse]
          commands.each do |command|
            next if command.start_with?("DS_") && fightstyle != "DS" || !command.start_with?("DS_") && fightstyle == "DS"
            if script == "Combinator" && command.include?("Azerite Azerite")
              azeriteStacks.each do |stacks|
                if stacks > 0
                  azCommand = command.gsub("Azerite Azerite", "#{stacks}A Azerite")
                else
                  azCommand = command.gsub("Azerite Azerite", "1A NoAzerite")
                end
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{azCommand} q"
              end
              # Do an additional run of talents with just the default profile (no azerite overrides)
              azCommand = command.gsub("Azerite Azerite", "1A Simple")
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{azCommand} q"
            elsif script == "Combinator" && command.include?("Essences ME")
              ["3E", "4E"].each do |etype|
                essenceCommand = command.gsub("Essences ME", "Essences #{etype}")
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{essenceCommand} q"
              end
            else
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} q"
            end
          end
        end
      end
    end
  end
end

### HAX: For display on HeroDamage, rename our DS reports to include T25 so they show as T25 fightstyle.
Dir.glob("#{SimcConfig["ReportsFolder"]}/*_DS_DS_*.{json,csv}").each do |file|
  puts "Renaming #{file} for T25..."
  File.rename(file, file.gsub(/_DS_DS_/, "_DS_T25_"))
end

puts "All batch simulations done! Press enter!"
gets
