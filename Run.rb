require_relative 'lib/SimcConfig'

toRun = {
  'AzeriteSimulation' => {
    'Death-Knight' => [
      'PR_Death_Knight_Blood',
      'PR_Death_Knight_Frost',
      'PR_Death_Knight_Unholy',
      'T22_Death_Knight_Blood',
    ],
    'Demon-Hunter' => [
      'PR_Demon_Hunter_Havoc',
      'PR_Demon_Hunter_Vengeance',
      'T22_Demon_Hunter_Havoc',
      'T22_Demon_Hunter_Vengeance',
    ],
    'Druid' => [
      'PR_Druid_Balance',
      'PR_Druid_Feral',
      'PR_Druid_Guardian',
      'T22_Druid_Balance',
      'T22_Druid_Feral',
      'T22_Druid_Guardian',
    ],
    'Hunter' => [
      'PR_Hunter_Beast_Mastery',
      'PR_Hunter_Marksmanship',
      'PR_Hunter_Survival',
      'T22_Hunter_Beast_Mastery',
      'T22_Hunter_Marksmanship',
      'T22_Hunter_Survival',
    ],
    'Mage' => [
      'PR_Mage_Arcane',
      'PR_Mage_Fire',
      'PR_Mage_Frost',
      'T22_Mage_Arcane',
      'T22_Mage_Fire',
      'T22_Mage_Frost',
    ],
    'Monk' => [
      'PR_Monk_Brewmaster',
      'PR_Monk_Windwalker',
      'T22_Monk_Brewmaster',
      'T22_Monk_Windwalker',
    ],
    'Paladin' => [
      'PR_Paladin_Protection',
      'PR_Paladin_Retribution',
      'T22_Paladin_Retribution',
    ],
    'Priest' => [
      'PR_Priest_Shadow',
      'T22_Priest_Shadow',
    ],
    'Rogue' => [
      'PR_Rogue_Assassination',
      'PR_Rogue_Assassination_Exsg',
      'PR_Rogue_Outlaw',
      'PR_Rogue_Outlaw_SnD',
      'PR_Rogue_Subtlety',
      'T22_Rogue_Assassination',
      'T22_Rogue_Assassination_Exsg',
      'T22_Rogue_Outlaw',
      'T22_Rogue_Outlaw_SnD',
      'T22_Rogue_Subtlety',
    ],
    'Shaman' => [
      'PR_Shaman_Elemental',
      'PR_Shaman_Enhancement',
      'T22_Shaman_Enhancement',
    ],
    'Warlock' => [
      'PR_Warlock_Affliction',
      'PR_Warlock_Demonology',
      'PR_Warlock_Destruction',
      'T22_Warlock_Affliction',
      'T22_Warlock_Demonology',
      'T22_Warlock_Destruction',
    ],
    'Warrior' => [
      'PR_Warrior_Arms',
      'PR_Warrior_Fury',
      'T22_Warrior_Arms',
      'T22_Warrior_Fury',
    ],
  },
  'Combinator' => {
    'Death-Knight' => [
      'PR_Death_Knight_Blood Death-Knight_Azerite Azerite xx200[23]3',
      'PR_Death_Knight_Frost Death-Knight_Azerite Azerite xx0x0xx',
      'PR_Death_Knight_Unholy Death-Knight_Azerite Azerite xx0x0xx',
      'T22_Death_Knight_Blood Death-Knight_Azerite Azerite xx200[23]3'
    ],
    'Demon-Hunter' => [
      'PR_Demon_Hunter_Havoc Demon-Hunter_Azerite Azerite xxx0x2x',
      'PR_Demon_Hunter_Vengeance Demon-Hunter_Azerite Azerite x[23]x[23]0x0',
      'T22_Demon_Hunter_Havoc Demon-Hunter_Azerite Azerite xxx0x2x',
      'T22_Demon_Hunter_Vengeance Demon-Hunter_Azerite Azerite x[23]x[23]0x0'
    ],
    'Druid' => [
      'PR_Druid_Balance Druid_Azerite Azerite x000xxx',
      'PR_Druid_Feral Druid_Azerite Azerite x000xxx',
      'PR_Druid_Guardian Druid_Azerite Azerite x000x0x',
      'T22_Druid_Balance Druid_Azerite Azerite x000xxx',
      'T22_Druid_Feral Druid_Azerite Azerite x000xxx',
      'T22_Druid_Guardian Druid_Azerite Azerite x000x0x'
    ],
    'Hunter' => [
      'PR_Hunter_Beast_Mastery Hunter_Azerite Azerite xx0x0xx',
      'PR_Hunter_Marksmanship Hunter_Azerite Azerite xx0x0xx',
      'PR_Hunter_Survival Hunter_Azerite Azerite xx0x0xx',
      'T22_Hunter_Beast_Mastery Hunter_Azerite Azerite xx0x0xx',
      'T22_Hunter_Marksmanship Hunter_Azerite Azerite xx0x0xx',
      'T22_Hunter_Survival Hunter_Azerite Azerite xx0x0xx'
    ],
    'Mage' => [
      'PR_Mage_Arcane Mage_Azerite Azerite x0xx0xx',
      'PR_Mage_Fire Mage_Azerite Azerite x0xx0xx',
      'PR_Mage_Frost Mage_Azerite Azerite x0xx0xx',
      'T22_Mage_Arcane Mage_Azerite Azerite x0xx0xx',
      'T22_Mage_Fire Mage_Azerite Azerite x0xx0xx',
      'T22_Mage_Frost Mage_Azerite Azerite x0xx0xx'
    ],
    'Monk' => [
      'PR_Monk_Brewmaster Monk_Azerite Azerite x0x00xx',
      'PR_Monk_Windwalker Monk_Azerite Azerite x0x00xx',
      'T22_Monk_Brewmaster Monk_Azerite Azerite x0x00xx',
      'T22_Monk_Windwalker Monk_Azerite Azerite x0x00xx'
    ],
    'Paladin' => [
      'PR_Paladin_Protection Paladin_Azerite Azerite xx0[01]00x',
      'PR_Paladin_Retribution Paladin_Azerite Azerite xx0x0[02]x',
      'T22_Paladin_Retribution Paladin_Azerite Azerite xx0x0[02]x'
    ],
    'Priest' => [
      'PR_Priest_Shadow Priest_Azerite Azerite x0x0xxx',
      'T22_Priest_Shadow Priest_Azerite Azerite x0x0xxx'
    ],
    'Rogue' => [
      'PR_Rogue_Assassination Rogue_Azerite Azerite xxx00[12]x',
      'PR_Rogue_Assassination_Exsg Rogue_Azerite Azerite xxx003x',
      'PR_Rogue_Outlaw Rogue_Azerite Azerite x3x00[12]x',
      'PR_Rogue_Outlaw_SnD Rogue_Azerite Azerite x3x003x',
      'PR_Rogue_Subtlety Rogue_Azerite Azerite xxx00xx',
      'T22_Rogue_Assassination Rogue_Azerite Azerite xxx00[12]x',
      'T22_Rogue_Assassination_Exsg Rogue_Azerite Azerite xxx003x',
      'T22_Rogue_Outlaw Rogue_Azerite Azerite x3x00[12]x',
      'T22_Rogue_Outlaw_SnD Rogue_Azerite Azerite x3x003x',
      'T22_Rogue_Subtlety Rogue_Azerite Azerite xxx00xx'
    ],
    'Shaman' => [
      'PR_Shaman_Elemental Shaman_Azerite Azerite xx0x0xx',
      'PR_Shaman_Enhancement Shaman_Azerite Azerite xx0x0xx',
      'T22_Shaman_Enhancement Shaman_Azerite Azerite xx0x0xx'
    ],
    'Warlock' => [
      'PR_Warlock_Affliction Warlock_Azerite Azerite xx0x0xx',
      'PR_Warlock_Demonology Warlock_Azerite Azerite xx0x0xx',
      'PR_Warlock_Destruction Warlock_Azerite Azerite xx0x0xx',
      'T22_Warlock_Affliction Warlock_Azerite Azerite xx0x0xx',
      'T22_Warlock_Demonology Warlock_Azerite Azerite xx0x0xx',
      'T22_Warlock_Destruction Warlock_Azerite Azerite xx0x0xx'
    ],
    'Warrior' => [
      'PR_Warrior_Arms Warrior_Azerite Azerite x3x2xxx',
      'PR_Warrior_Fury Warrior_Azerite Azerite x3x2xxx',
      'T22_Warrior_Arms Warrior_Azerite Azerite x3x2xxx',
      'T22_Warrior_Fury Warrior_Azerite Azerite x3x2xxx'
    ],
  },
  'RaceSimulation' => {
    'Death-Knight' => [
      'PR_Death_Knight_Blood',
      'PR_Death_Knight_Frost',
      'PR_Death_Knight_Unholy',
      'T22_Death_Knight_Blood',
    ],
    'Demon-Hunter' => [
      'PR_Demon_Hunter_Havoc',
      'PR_Demon_Hunter_Vengeance',
      'T22_Demon_Hunter_Havoc',
      'T22_Demon_Hunter_Vengeance',
    ],
    'Druid' => [
      'PR_Druid_Balance',
      'PR_Druid_Feral',
      'PR_Druid_Guardian',
      'T22_Druid_Balance',
      'T22_Druid_Feral',
      'T22_Druid_Guardian',
    ],
    'Hunter' => [
      'PR_Hunter_Beast_Mastery',
      'PR_Hunter_Marksmanship',
      'PR_Hunter_Survival',
      'T22_Hunter_Beast_Mastery',
      'T22_Hunter_Marksmanship',
      'T22_Hunter_Survival',
    ],
    'Mage' => [
      'PR_Mage_Arcane',
      'PR_Mage_Fire',
      'PR_Mage_Frost',
      'T22_Mage_Arcane',
      'T22_Mage_Fire',
      'T22_Mage_Frost',
    ],
    'Monk' => [
      'PR_Monk_Brewmaster',
      'PR_Monk_Windwalker',
      'T22_Monk_Brewmaster',
      'T22_Monk_Windwalker',
    ],
    'Paladin' => [
      'PR_Paladin_Protection',
      'PR_Paladin_Retribution',
      'T22_Paladin_Retribution',
    ],
    'Priest' => [
      'PR_Priest_Shadow',
      'T22_Priest_Shadow',
    ],
    'Rogue' => [
      'PR_Rogue_Assassination',
      'PR_Rogue_Assassination_Exsg',
      'PR_Rogue_Outlaw',
      'PR_Rogue_Outlaw_SnD',
      'PR_Rogue_Subtlety',
      'T22_Rogue_Assassination',
      'T22_Rogue_Assassination_Exsg',
      'T22_Rogue_Outlaw',
      'T22_Rogue_Outlaw_SnD',
      'T22_Rogue_Subtlety',
    ],
    'Shaman' => [
      'PR_Shaman_Elemental',
      'PR_Shaman_Enhancement',
      'T22_Shaman_Enhancement',
    ],
    'Warlock' => [
      'PR_Warlock_Affliction',
      'PR_Warlock_Demonology',
      'PR_Warlock_Destruction',
      'T22_Warlock_Affliction',
      'T22_Warlock_Demonology',
      'T22_Warlock_Destruction',
    ],
    'Warrior' => [
      'PR_Warrior_Arms',
      'PR_Warrior_Fury',
      'T22_Warrior_Arms',
      'T22_Warrior_Fury',
    ],
  },
  'TrinketSimulation' => {
    'Death-Knight' => [
      'PR_Death_Knight_Blood Strength',
      'PR_Death_Knight_Frost Strength',
      'PR_Death_Knight_Unholy Strength',
      'T22_Death_Knight_Blood Strength',
    ],
    'Demon-Hunter' => [
      'PR_Demon_Hunter_Havoc Agility',
      'PR_Demon_Hunter_Vengeance Agility',
      'T22_Demon_Hunter_Havoc Agility',
      'T22_Demon_Hunter_Vengeance Agility',
    ],
    'Druid' => [
      'PR_Druid_Balance Intelligence',
      'PR_Druid_Feral Agility',
      'PR_Druid_Guardian Agility',
      'T22_Druid_Balance Intelligence',
      'T22_Druid_Feral Agility',
      'T22_Druid_Guardian Agility',
    ],
    'Hunter' => [
      'PR_Hunter_Beast_Mastery Agility',
      'PR_Hunter_Marksmanship Agility',
      'PR_Hunter_Survival Agility',
      'T22_Hunter_Beast_Mastery Agility',
      'T22_Hunter_Marksmanship Agility',
      'T22_Hunter_Survival Agility',
    ],
    'Mage' => [
      'PR_Mage_Arcane Intelligence',
      'PR_Mage_Fire Intelligence',
      'PR_Mage_Frost Intelligence',
      'T22_Mage_Arcane Intelligence',
      'T22_Mage_Fire Intelligence',
      'T22_Mage_Frost Intelligence',
    ],
    'Monk' => [
      'PR_Monk_Brewmaster Agility',
      'PR_Monk_Windwalker Agility',
      'T22_Monk_Brewmaster Agility',
      'T22_Monk_Windwalker Agility',
    ],
    'Paladin' => [
      'PR_Paladin_Protection Strength',
      'PR_Paladin_Retribution Strength',
      'T22_Paladin_Retribution Strength',
    ],
    'Priest' => [
      'PR_Priest_Shadow Intelligence',
      'T22_Priest_Shadow Intelligence',
    ],
    'Rogue' => [
      'PR_Rogue_Assassination Agility',
      'PR_Rogue_Assassination_Exsg Agility',
      'PR_Rogue_Outlaw Agility',
      'PR_Rogue_Outlaw_SnD Agility',
      'PR_Rogue_Subtlety Agility',
      'T22_Rogue_Assassination Agility',
      'T22_Rogue_Assassination_Exsg Agility',
      'T22_Rogue_Outlaw Agility',
      'T22_Rogue_Outlaw_SnD Agility',
      'T22_Rogue_Subtlety Agility',
    ],
    'Shaman' => [
      'PR_Shaman_Elemental Intelligence',
      'PR_Shaman_Enhancement Agility',
      'T22_Shaman_Enhancement Agility',
    ],
    'Warlock' => [
      'PR_Warlock_Affliction Intelligence',
      'PR_Warlock_Demonology Intelligence',
      'PR_Warlock_Destruction Intelligence',
      'T22_Warlock_Affliction Intelligence',
      'T22_Warlock_Demonology Intelligence',
      'T22_Warlock_Destruction Intelligence',
    ],
    'Warrior' => [
      'PR_Warrior_Arms Strength',
      'PR_Warrior_Fury Strength',
      'T22_Warrior_Arms Strength',
      'T22_Warrior_Fury Strength',
    ],
  },
}

orders = SimcConfig["RunOrders"]
wowclasses = SimcConfig["RunClasses"]

orders.each do |order|
  scripts = order[0]
  fightstyles = order[1]
  scripts.each do |script|
    fightstyles.each do |fightstyle|
      wowclasses.each do |wowclass|
        commands = toRun[script][wowclass]
        commands.each do |command|
          system "bundle exec ruby #{script}.rb #{fightstyle} #{wowclass} #{command} q"
        end
      end
    end
  end
end

puts "All batch simulations done! Press enter!"
gets
