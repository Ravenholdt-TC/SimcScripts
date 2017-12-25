# This script was used to convert CSV reports to JSON when we switched our output format.
# It's a one-use script as you see, so not very optimized (as most of the scripts in this folder).
# It'll likely no longer work in the future as we improve our lib.

require 'rubygems'
require 'bundler/setup'
require 'json'
require 'csv'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'
require_relative 'lib/SimcConfig'

# Convert Combinator CSV File
def Combinator (csvFile, jsonFile)
  report = [ ]

  CSV.foreach(csvFile, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
    actor = [ ]
    row.each_with_index{ |value, index|
      if index == 1 or index == 2
        actor.push(value.to_str)
      else
        actor.push(value.to_i)
      end
    }
    report.push(actor)
  end

  # Sort the report by the DPS value in DESC order
  report.sort! { |x,y| y[3] <=> x[3] }

  # Add the initial rank
  report.each_with_index { |actor, index|
    actor.unshift(index + 1)
  }

  JSONParser.WriteFile(jsonFile, report)
end

# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Demon_Hunter_Havoc.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Demon_Hunter_Havoc.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Shaman_Enhancement.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Shaman_Enhancement.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Mage_Arcane.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Mage_Arcane.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Mage_Fire.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Mage_Fire.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Mage_Frost.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Mage_Frost.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Mage_Arcane.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Mage_Arcane.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warrior_Fury.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warrior_Fury.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warlock_Demonology.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warlock_Demonology.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warlock_Destruction.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warlock_Destruction.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warrior_Arms.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warrior_Arms.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warlock_Affliction.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warlock_Affliction.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warlock_Demonology.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warlock_Demonology.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warlock_Destruction.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Warlock_Destruction.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warlock_Affliction.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warlock_Affliction.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Paladin_Retribution.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Paladin_Retribution.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Hunter_Beast_Mastery-Crit-Build.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Hunter_Beast_Mastery-Crit-Build.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Hunter_Beast_Mastery-Mastery-Build.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Hunter_Beast_Mastery-Mastery-Build.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Hunter_Marksmanship.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Hunter_Marksmanship.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Hunter_Survival.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Hunter_Survival.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Hunter_Marksmanship.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Hunter_Marksmanship.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Hunter_Beast_Mastery-Crit-Build.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Hunter_Beast_Mastery-Crit-Build.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Hunter_Beast_Mastery-Mastery-Build.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Hunter_Beast_Mastery-Mastery-Build.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Druid_Feral.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Druid_Feral.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Druid_Balance.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Druid_Balance.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Druid_Feral.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Druid_Feral.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Druid_Balance.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Druid_Balance.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Monk_Windwalker.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Monk_Windwalker.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Monk_Windwalker.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Monk_Windwalker.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_PR_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_PR_Rogue_Subtlety.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_PR_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_PR_Rogue_Outlaw.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T19_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T19_Rogue_Subtlety.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T19_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T19_Rogue_Outlaw.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T20_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T20_Rogue_Subtlety.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T20_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T20_Rogue_Outlaw.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Subtlety.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Outlaw-Slice_and_Dice.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Outlaw-Slice_and_Dice.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Outlaw-Roll_the_Bones.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Outlaw-Roll_the_Bones.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Subtlety.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Outlaw-Slice_and_Dice.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Outlaw-Slice_and_Dice.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Outlaw-Roll_the_Bones.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Outlaw-Roll_the_Bones.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_PR_Rogue_Assassination.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_PR_Rogue_Assassination.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T19_Rogue_Assassination.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T19_Rogue_Assassination.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T20_Rogue_Assassination.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T20_Rogue_Assassination.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Death_Knight_Unholy.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Death_Knight_Unholy.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Death_Knight_Frost.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Death_Knight_Frost.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Death_Knight_Unholy.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Death_Knight_Unholy.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Death_Knight_Frost.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Death_Knight_Frost.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Assassination-Bleed.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Assassination-Bleed.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Assassination-Poison.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Assassination-Poison.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Assassination-Bleed.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Assassination-Bleed.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Assassination-Poison.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Assassination-Poison.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Assassination-Poison_FoK.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Rogue_Assassination-Poison_FoK.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Assassination-Poison_FoK.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Rogue_Assassination-Poison_FoK.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Demon_Hunter_Havoc.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Demon_Hunter_Havoc.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Shaman_Enhancement.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Shaman_Enhancement.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Priest_Shadow.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Priest_Shadow.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Priest_Shadow.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Priest_Shadow.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Hunter_Survival.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Hunter_Survival.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warrior_Fury.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warrior_Fury.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warrior_Arms.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Warrior_Arms.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Paladin_Retribution.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Paladin_Retribution.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Shaman_Elemental.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21_Shaman_Elemental.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Mage_Fire.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Mage_Fire.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Mage_Frost.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Mage_Frost.json")
# Combinator("#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Shaman_Elemental.csv", "#{SimcConfig['ReportsFolder']}/Combinator_1T_T21H_Shaman_Elemental.json")

# Convert Trinkets CSV File
def Trinkets (csvFile, jsonFile)
  report = [ ]

  CSV.foreach(csvFile, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
    actor = [ ]
    row.each_with_index{ |value, index|
      if index == 0 || $. == 1
        actor.push(value.to_str)
      else
        actor.push(value.to_i)
      end
    }
    report.push(actor)
  end

  JSONParser.WriteFile(jsonFile, report)
end

# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Monk_Windwalker.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Monk_Windwalker.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Monk_Windwalker.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Monk_Windwalker.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T19_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T19_Rogue_Subtlety.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T19_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T19_Rogue_Outlaw.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Subtlety_DfA.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Subtlety_DfA.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Subtlety.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Outlaw_SnD.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Outlaw_SnD.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Outlaw.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Subtlety_DfA-Soul+Insignia.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Subtlety_DfA-Soul+Insignia.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Subtlety_DfA-Mantle+Hands.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Subtlety_DfA-Mantle+Hands.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Subtlety.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Outlaw_SnD.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Outlaw_SnD.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Outlaw.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Death_Knight_Frost-Cold_Heart+Runic_Attenuation.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Death_Knight_Frost-Cold_Heart+Runic_Attenuation.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Death_Knight_Unholy.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Death_Knight_Unholy.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Death_Knight_Frost.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Death_Knight_Frost.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T19_Rogue_Assassination.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T19_Rogue_Assassination.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Assassination_Exsg.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Assassination_Exsg.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Assassination.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Rogue_Assassination.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Death_Knight_Blood.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Death_Knight_Blood.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Death_Knight_Unholy.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Death_Knight_Unholy.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Death_Knight_Frost.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Death_Knight_Frost.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination_Exsg.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination_Exsg.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination-T21_4+T20_2_Boots+Bracers_FoK.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination-T21_4+T20_2_Boots+Bracers_FoK.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination-T21_4+T20_2_Boots+Bracers.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination-T21_4+T20_2_Boots+Bracers.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination-Mantle+Bracers_FoK.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination-Mantle+Bracers_FoK.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination-Mantle+Bracers.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Rogue_Assassination-Mantle+Bracers.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warrior_Fury.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warrior_Fury.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warrior_Arms.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warrior_Arms.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warrior_Fury.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warrior_Fury.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warrior_Arms.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warrior_Arms.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warlock_Destruction.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warlock_Destruction.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warlock_Demonology.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warlock_Demonology.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warlock_Affliction.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Warlock_Affliction.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warlock_Destruction.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warlock_Destruction.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warlock_Demonology.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warlock_Demonology.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warlock_Affliction.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Warlock_Affliction.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Shaman_Enhancement.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Shaman_Enhancement.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Shaman_Elemental.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Shaman_Elemental.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Shaman_Enhancement.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Shaman_Enhancement.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Shaman_Elemental.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Shaman_Elemental.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Priest_Shadow_S2M.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Priest_Shadow_S2M.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Priest_Shadow.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Priest_Shadow.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Priest_Shadow_S2M.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Priest_Shadow_S2M.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Priest_Shadow.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Priest_Shadow.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Paladin_Retribution.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Paladin_Retribution.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Paladin_Retribution.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Paladin_Retribution.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Mage_Frost.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Mage_Frost.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Mage_Fire.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Mage_Fire.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Mage_Arcane.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Mage_Arcane.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Mage_Frost.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Mage_Frost.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Mage_Fire.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Mage_Fire.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Mage_Arcane.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Mage_Arcane.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Hunter_Survival.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Hunter_Survival.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Hunter_Marksmanship.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Hunter_Marksmanship.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Hunter_Beast_Mastery.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Hunter_Beast_Mastery.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Demon_Hunter_Havoc.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Demon_Hunter_Havoc.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Demon_Hunter_Havoc.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Demon_Hunter_Havoc.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Survival.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Survival.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Marksmanship.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Marksmanship.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery_Stomp.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery_Stomp.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery_DireFrenzy.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery_DireFrenzy.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Druid_Balance-Stellar_Drift.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Druid_Balance-Stellar_Drift.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Druid_Feral.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Druid_Feral.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Druid_Balance.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T20_Druid_Balance.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Druid_Feral.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Druid_Feral.json")
# Trinkets("#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Druid_Balance.csv", "#{SimcConfig['ReportsFolder']}/TrinketSimulation_1T_T21_Druid_Balance.json")

# Convert Relics CSV File
def Relics (csvFile, jsonFile)
  report = [ ]

  CSV.foreach(csvFile, quote_char: '"', col_sep: ',', row_sep: :auto, headers: false) do |row|
    actor = [ ]
    row.each_with_index{ |value, index|
      if index.modulo(2) == 0
        actor.push(value.to_str)
      else
        actor.push(value.to_i)
      end
    }
    report.push(actor)
  end

  t2names = {
    "LightSpeed" => "Light Speed",
    "InfusionOfLight" => "Infusion of Light",
    "SecureInTheLight" => "Secure in the Light",
    "Shocklight" => "Shocklight",
    "MasterOfShadows" => "Master of Shadows",
    "MurderousIntent" => "Murderous Intent",
    "Shadowbind" => "Shadowbind",
    "TormentTheWeak" => "Torment the Weak",
    "ChaoticDarkness" => "Chaotic Darkness",
    "DarkSorrows" => "Dark Sorrows"
  }
  max_columns = 1
  report.each do |actor|
    actor[0] = t2names[actor[0]] if t2names[actor[0]]
    max_columns = actor.length if actor.length > max_columns
  end
  max_columns -= 1
  max_columns /= 2
  # Header
  def hashElementType (value)
    return { "type" => value }
  end
  header = [ hashElementType("string") ]
  for i in 1..max_columns
    header.push(hashElementType("number"))
    header.push(hashElementType("string"))
  end
  report.unshift(header)

  JSONParser.WriteFile(jsonFile, report)
end

# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Priest_Shadow.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Priest_Shadow.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Priest_Shadow_S2M.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Priest_Shadow_S2M.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Assassination.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Assassination.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Assassination_Exsg.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Assassination_Exsg.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Outlaw.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Outlaw_SnD.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Outlaw_SnD.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Subtlety.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Subtlety_DfA.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Rogue_Subtlety_DfA.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Shaman_Elemental.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Shaman_Elemental.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Shaman_Enhancement.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Shaman_Enhancement.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warlock_Affliction.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warlock_Affliction.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warlock_Demonology.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warlock_Demonology.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warlock_Destruction.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warlock_Destruction.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warrior_Arms.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warrior_Arms.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warrior_Fury.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Warrior_Fury.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Death_Knight_Blood.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Death_Knight_Blood.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Death_Knight_Frost.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Death_Knight_Frost.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Death_Knight_Frost-Cold_Heart+Runic_Attenuation.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Death_Knight_Frost-Cold_Heart+Runic_Attenuation.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Death_Knight_Unholy.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Death_Knight_Unholy.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Demon_Hunter_Havoc.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Demon_Hunter_Havoc.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Druid_Balance.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Druid_Balance.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Druid_Balance-Stellar_Drift.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Druid_Balance-Stellar_Drift.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Druid_Feral.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Druid_Feral.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Beast_Mastery_DireFrenzy.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Beast_Mastery_DireFrenzy.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Beast_Mastery_Stomp.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Beast_Mastery_Stomp.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Marksmanship.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Marksmanship.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Survival.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Hunter_Survival.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Mage_Arcane.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Mage_Arcane.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Mage_Fire.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Mage_Fire.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Mage_Frost.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Mage_Frost.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Monk_Windwalker.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Monk_Windwalker.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Paladin_Retribution.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Paladin_Retribution.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Priest_Shadow.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Priest_Shadow.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Priest_Shadow_S2M.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Priest_Shadow_S2M.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination_Exsg.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination_Exsg.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination-Mantle+Bracers.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination-Mantle+Bracers.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination-Mantle+Bracers_FoK.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination-Mantle+Bracers_FoK.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots_FoK.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots_FoK.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Outlaw.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Outlaw_SnD.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Outlaw_SnD.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Subtlety.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Subtlety_DfA-Mantle+Hands.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Subtlety_DfA-Mantle+Hands.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Subtlety_DfA-Soul+Insignia.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Rogue_Subtlety_DfA-Soul+Insignia.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Shaman_Elemental.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Shaman_Elemental.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Shaman_Enhancement.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Shaman_Enhancement.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warlock_Affliction.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warlock_Affliction.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warlock_Demonology.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warlock_Demonology.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warlock_Destruction.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warlock_Destruction.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warrior_Arms.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warrior_Arms.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warrior_Fury.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T21_Warrior_Fury.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T19_Rogue_Assassination.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T19_Rogue_Assassination.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T19_Rogue_Outlaw.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T19_Rogue_Outlaw.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T19_Rogue_Subtlety.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T19_Rogue_Subtlety.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Death_Knight_Frost.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Death_Knight_Frost.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Death_Knight_Unholy.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Death_Knight_Unholy.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Demon_Hunter_Havoc.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Demon_Hunter_Havoc.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Druid_Balance.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Druid_Balance.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Druid_Feral.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Druid_Feral.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Hunter_Beast_Mastery.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Hunter_Beast_Mastery.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Hunter_Marksmanship.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Hunter_Marksmanship.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Hunter_Survival.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Hunter_Survival.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Mage_Arcane.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Mage_Arcane.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Mage_Fire.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Mage_Fire.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Mage_Frost.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Mage_Frost.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Monk_Windwalker.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Monk_Windwalker.json")
# Relics("#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Paladin_Retribution.csv", "#{SimcConfig['ReportsFolder']}/convert/RelicSimulation_1T_T20_Paladin_Retribution.json")

puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
