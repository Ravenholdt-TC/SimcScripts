require "rubygems"
require "bundler/setup"
require "optparse"
require_relative "lib/SimcConfig"

to_run = {
  "AzeriteSimulation" => { ### !!! This will also be used for Essence and Race simulations
    "Death-Knight" => [
      "T25_Death_Knight_Blood",
      "T25_Death_Knight_Frost",
      "T25_Death_Knight_Unholy",
    ],
    "Demon-Hunter" => [
      "T25_Demon_Hunter_Havoc",
      "T25_Demon_Hunter_Havoc_Momentum",
      "T25_Demon_Hunter_Vengeance",
    ],
    "Druid" => [
      "T25_Druid_Balance",
      "T25_Druid_Feral",
      "T25_Druid_Guardian",
    ],
    "Hunter" => [
      "T25_Hunter_Beast_Mastery",
      "T25_Hunter_Marksmanship",
      "T25_Hunter_Survival",
    ],
    "Mage" => [
      "T25_Mage_Arcane",
      "T25_Mage_Fire",
      "T25_Mage_Frost",
    ],
    "Monk" => [
      "T25_Monk_Brewmaster",
      "T25_Monk_Windwalker",
      "T25_Monk_Windwalker_Serenity",
    ],
    "Paladin" => [
      "T25_Paladin_Protection",
      "T25_Paladin_Retribution",
    ],
    "Priest" => [
      "T25_Priest_Shadow",
    ],
    "Rogue" => [
      "T25_Rogue_Assassination",
      "T25_Rogue_Outlaw",
      "T25_Rogue_Subtlety",
    ],
    "Shaman" => [
      "T25_Shaman_Elemental",
      "T25_Shaman_Enhancement",
    ],
    "Warlock" => [
      "T25_Warlock_Affliction",
      "T25_Warlock_Demonology",
      "T25_Warlock_Destruction",
    ],
    "Warrior" => [
      "T25_Warrior_Arms",
      "T25_Warrior_Fury",
      # "T25_Warrior_Protection",
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
      # Essence sims
      "T25_Death_Knight_Blood Death-Knight_Essences 1E xxx20xx",
      "T25_Death_Knight_Frost Death-Knight_Essences 1E xx0x0xx",
      "T25_Death_Knight_Unholy Death-Knight_Essences 1E xx0x0xx",
      "T25_Death_Knight_Blood Death-Knight_Essences ME default",
      "T25_Death_Knight_Frost Death-Knight_Essences ME default",
      "T25_Death_Knight_Unholy Death-Knight_Essences ME default",
    ],
    "Demon-Hunter" => [
      "T25_Demon_Hunter_Havoc Demon-Hunter_Azerite Azerite xxx0x2[13]",
      "T25_Demon_Hunter_Havoc_Momentum Demon-Hunter_Azerite Azerite xxx0x22",
      "T25_Demon_Hunter_Vengeance Demon-Hunter_Azerite Azerite xxxx1x1",
      # Essence sims
      "T25_Demon_Hunter_Havoc Demon-Hunter_Essences 1E xxx0x2[13]",
      "T25_Demon_Hunter_Havoc_Momentum Demon-Hunter_Essences 1E xxx0x22",
      "T25_Demon_Hunter_Vengeance Demon-Hunter_Essences 1E xxxx1x1",
      "T25_Demon_Hunter_Havoc Demon-Hunter_Essences ME default",
      "T25_Demon_Hunter_Havoc_Momentum Demon-Hunter_Essences ME default",
      "T25_Demon_Hunter_Vengeance Demon-Hunter_Essences ME default",
    ],
    "Druid" => [
      "T25_Druid_Balance Druid_Azerite Azerite x000xxx",
      "T25_Druid_Feral Druid_Azerite Azerite x000xxx",
      "T25_Druid_Guardian Druid_Azerite Azerite x030xxx",
      # Essence sims
      "T25_Druid_Balance Druid_Essences 1E x000xxx",
      "T25_Druid_Feral Druid_Essences 1E x000xxx",
      "T25_Druid_Guardian Druid_Essences 1E x030xxx",
      "T25_Druid_Balance Druid_Essences ME default",
      "T25_Druid_Feral Druid_Essences ME default",
      "T25_Druid_Guardian Druid_Essences ME default",
    ],
    "Hunter" => [
      "T25_Hunter_Beast_Mastery Hunter_Azerite Azerite xx0x0xx",
      "T25_Hunter_Marksmanship Hunter_Azerite Azerite xx0x0xx",
      "T25_Hunter_Survival Hunter_Azerite Azerite xx0x0xx",
      # Essence sims
      "T25_Hunter_Beast_Mastery Hunter_Essences 1E xx0x0xx",
      "T25_Hunter_Marksmanship Hunter_Essences 1E xx0x0xx",
      "T25_Hunter_Survival Hunter_Essences 1E xx0x0xx",
      "T25_Hunter_Beast_Mastery Hunter_Essences ME default",
      "T25_Hunter_Marksmanship Hunter_Essences ME default",
      "T25_Hunter_Survival Hunter_Essences ME default",
    ],
    "Mage" => [
      "T25_Mage_Arcane Mage_Azerite Azerite x0xx0xx",
      "T25_Mage_Fire Mage_Azerite Azerite x0xx0xx",
      "T25_Mage_Frost Mage_Azerite Azerite x0xx0xx",
      # Essence sims
      "T25_Mage_Arcane Mage_Essences 1E x0xx0xx",
      "T25_Mage_Fire Mage_Essences 1E x0xx0xx",
      "T25_Mage_Frost Mage_Essences 1E x0xx0xx",
      "T25_Mage_Arcane Mage_Essences ME default",
      "T25_Mage_Fire Mage_Essences ME default",
      "T25_Mage_Frost Mage_Essences ME default",
    ],
    "Monk" => [
      "T25_Monk_Brewmaster Monk_Azerite Azerite x0x01xx",
      "T25_Monk_Windwalker Monk_Azerite Azerite x0x20x[12]",
      "T25_Monk_Windwalker_Serenity Monk_Azerite Azerite x0x20x3",
      # Essence sims
      "T25_Monk_Brewmaster Monk_Essences 1E x0x01xx",
      "T25_Monk_Windwalker Monk_Essences 1E x0x20x[12]",
      "T25_Monk_Windwalker_Serenity Monk_Essences 1E x0x20x3",
      "T25_Monk_Brewmaster Monk_Essences ME default",
      "T25_Monk_Windwalker Monk_Essences ME default",
      "T25_Monk_Windwalker_Serenity Monk_Essences ME default",
    ],
    "Paladin" => [
      "T25_Paladin_Protection Paladin_Azerite Azerite xx00x0x",
      "T25_Paladin_Retribution Paladin_Azerite Azerite xx00x0x",
      # Essence sims
      "T25_Paladin_Protection Paladin_Essences 1E xx00x0x",
      "T25_Paladin_Retribution Paladin_Essences 1E xx00x0x",
      "T25_Paladin_Protection Paladin_Essences ME default",
      "T25_Paladin_Retribution Paladin_Essences ME default",
    ],
    "Priest" => [
      "T25_Priest_Shadow Priest_Azerite Azerite x0x0xxx",
      # Essence sims
      "T25_Priest_Shadow Priest_Essences 1E x0x0xxx",
      "T25_Priest_Shadow Priest_Essences ME default",
    ],
    "Rogue" => [
      "T25_Rogue_Assassination Rogue_Azerite Azerite xxx00xx",
      "T25_Rogue_Outlaw Rogue_Azerite Azerite x0x00xx",
      "T25_Rogue_Subtlety Rogue_Azerite Azerite xxx00xx",
      # Essence sims
      "T25_Rogue_Assassination Rogue_Essences 1E xxx00xx",
      "T25_Rogue_Outlaw Rogue_Essences 1E x0x00xx",
      "T25_Rogue_Subtlety Rogue_Essences 1E xxx00xx",
      "T25_Rogue_Assassination Rogue_Essences ME default",
      "T25_Rogue_Outlaw Rogue_Essences ME default",
      "T25_Rogue_Subtlety Rogue_Essences ME default",
    ],
    "Shaman" => [
      "T25_Shaman_Elemental Shaman_Azerite Azerite xx0x0xx",
      "T25_Shaman_Enhancement Shaman_Azerite Azerite xx0x0xx",
      # Essence sims
      "T25_Shaman_Elemental Shaman_Essences 1E xx0x0xx",
      "T25_Shaman_Enhancement Shaman_Essences 1E xx0x0xx",
      "T25_Shaman_Elemental Shaman_Essences ME default",
      "T25_Shaman_Enhancement Shaman_Essences ME default",
    ],
    "Warlock" => [
      "T25_Warlock_Affliction Warlock_Azerite Azerite xx0x0xx",
      "T25_Warlock_Demonology Warlock_Azerite Azerite xx0x0xx",
      "T25_Warlock_Destruction Warlock_Azerite Azerite xx0x0xx",
      # Essence sims
      "T25_Warlock_Affliction Warlock_Essences 1E xx0x0xx",
      "T25_Warlock_Demonology Warlock_Essences 1E xx0x0xx",
      "T25_Warlock_Destruction Warlock_Essences 1E xx0x0xx",
      "T25_Warlock_Affliction Warlock_Essences ME default",
      "T25_Warlock_Demonology Warlock_Essences ME default",
      "T25_Warlock_Destruction Warlock_Essences ME default",
    ],
    "Warrior" => [
      "T25_Warrior_Arms Warrior_Azerite Azerite x3x2xxx",
      "T25_Warrior_Fury Warrior_Azerite Azerite x3x2xxx",
      # "T25_Warrior_Protection Warrior_Azerite Azerite x3x22xx",
      # Essence sims
      "T25_Warrior_Arms Warrior_Essences 1E x3x2xxx",
      "T25_Warrior_Fury Warrior_Essences 1E x3x2xxx",
      # "T25_Warrior_Protection Warrior_Essences 1E x3x22xx",
      "T25_Warrior_Arms Warrior_Essences ME default",
      "T25_Warrior_Fury Warrior_Essences ME default",
      # "T25_Warrior_Protection Warrior_Essences ME default",
    ],
  },
  "TrinketSimulation" => {
    "Death-Knight" => [
      "T25_Death_Knight_Blood Strength",
      "T25_Death_Knight_Frost Strength",
      "T25_Death_Knight_Unholy Strength",
    ],
    "Demon-Hunter" => [
      "T25_Demon_Hunter_Havoc Agility",
      "T25_Demon_Hunter_Havoc_Momentum Agility",
      "T25_Demon_Hunter_Vengeance Agility",
    ],
    "Druid" => [
      "T25_Druid_Balance Intelligence",
      "T25_Druid_Feral Agility",
      "T25_Druid_Guardian Agility",
    ],
    "Hunter" => [
      "T25_Hunter_Beast_Mastery Agility",
      "T25_Hunter_Marksmanship Agility",
      "T25_Hunter_Survival Agility",
    ],
    "Mage" => [
      "T25_Mage_Arcane Intelligence",
      "T25_Mage_Fire Intelligence",
      "T25_Mage_Frost Intelligence",
    ],
    "Monk" => [
      "T25_Monk_Brewmaster Agility",
      "T25_Monk_Windwalker Agility",
      "T25_Monk_Windwalker_Serenity Agility",
    ],
    "Paladin" => [
      "T25_Paladin_Protection Strength",
      "T25_Paladin_Retribution Strength",
    ],
    "Priest" => [
      "T25_Priest_Shadow Intelligence",
    ],
    "Rogue" => [
      "T25_Rogue_Assassination Agility",
      "T25_Rogue_Outlaw Agility",
      "T25_Rogue_Subtlety Agility",
    ],
    "Shaman" => [
      "T25_Shaman_Elemental Intelligence",
      "T25_Shaman_Enhancement Agility",
    ],
    "Warlock" => [
      "T25_Warlock_Affliction Intelligence",
      "T25_Warlock_Demonology Intelligence",
      "T25_Warlock_Destruction Intelligence",
    ],
    "Warrior" => [
      "T25_Warrior_Arms Strength",
      "T25_Warrior_Fury Strength",
      # "T25_Warrior_Protection Strength",
    ],
  },
}

# Make links for sims using the same input
to_run["EssenceSimulation"] = to_run["AzeriteSimulation"]
to_run["RaceSimulation"] = to_run["AzeriteSimulation"]

orders = SimcConfig["RunOrders"]
wow_classes = SimcConfig["RunClasses"]
azeriteStacks = SimcConfig["RunCombinatorAzeriteStacks"]

wow_classes.each do |wow_class|
  orders.each do |steps|
    steps.each do |order|
      scripts = order[0].clone
      fightstyles = order[1].clone
      fightstyles.each do |fightstyle|
        scripts.each do |script|
          commands = to_run[script][wow_class].clone
          commands.each do |command|
            if script == "Combinator" && command.include?("Azerite Azerite")
              azeriteStacks.each do |stacks|
                if stacks > 0
                  azCommand = command.gsub("Azerite Azerite", "#{stacks}A Azerite")
                else
                  azCommand = command.gsub("Azerite Azerite", "1A NoAzerite")
                end
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} Default #{azCommand} q"
              end
              # Do an additional run of talents with just the default profile (no azerite overrides)
              azCommand = command.gsub("Azerite Azerite", "1A Simple")
              system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} Default #{azCommand} q"
            elsif script == "Combinator" && command.include?("Essences ME")
              ["4E"].each do |etype|
                essenceCommand = command.gsub("Essences ME", "Essences #{etype}")
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} Default #{essenceCommand} q"
              end
            else
              # TODO: Remove manual no covenant hack when updating for Shadowlands and update commands above
              if script == "Combinator"
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} Default #{command} q"
              else
                system "bundle exec ruby #{script}.rb #{fightstyle} #{wow_class} #{command} q"
              end
            end
          end
        end
      end
    end
  end
end

puts "All batch simulations done! Press enter!"
gets
