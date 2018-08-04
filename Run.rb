require_relative 'lib/SimcConfig'

toRun = {
  'Combinator' => {
    'Death-Knight' => [
      'T21_Death_Knight_Frost Death_Knight_Frost T21 xx0x0xx',
      'T21_Death_Knight_Unholy Death_Knight_Unholy T21 xx0x0xx'
    ],
    'Demon-Hunter' => [
      'T21_Demon_Hunter_Havoc Demon_Hunter T21 xxx0x2x'
    ],
    'Druid' => [
      'T21_Druid_Balance Druid_Balance T21 x000xxx',
      'T21_Druid_Feral Druid_Feral T21 x000xxx'
    ],
    'Hunter' => [
      'T21_Hunter_Beast_Mastery Hunter_Beast_Mastery T21 xx0x0xx',
      'T21_Hunter_Marksmanship Hunter_Marksmanship T21 xx0x0xx',
      'T21_Hunter_Survival Hunter_Survival T21 xx0x0xx'
    ],
    'Mage' => [
      'T21_Mage_Arcane Mage_Arcane T21 x0xx0xx',
      'T21_Mage_Fire Mage_Fire T21 x0xx0xx',
      'T21_Mage_Frost Mage_Frost T21 x0xx0xx'
    ],
    'Monk' => [
      'T21_Monk_Windwalker Monk T21 x0x00xx'
    ],
    'Paladin' => [
      'T21_Paladin_Retribution Paladin T21 xx0x0[02]x'
    ],
    'Priest' => [
      'T21_Priest_Shadow Priest_Shadow T21 x0x0xxx'
    ],
    'Rogue' => [
      'T21_Rogue_Assassination-Poison Rogue T21 xxx00[12]x',
      'T21_Rogue_Assassination-Bleed Rogue_Assassination_Exsg T21 xxx003x',
      'T21_Rogue_Outlaw-Roll_the_Bones Rogue T21 x3x00[12]x',
      'T21_Rogue_Outlaw-Slice_and_Dice Rogue_Outlaw_SnD T21 x3x003x',
      'T21_Rogue_Subtlety Rogue T21 xxx00xx'
    ],
    'Shaman' => [
      'T21_Shaman_Elemental Shaman_Elemental T21 xx0x0xx',
      'T21_Shaman_Enhancement Shaman_Enhancement T21 xx0x0xx'
    ],
    'Warlock' => [
      'T21_Warlock_Affliction Warlock_Affliction T21 xx0x0xx',
      'T21_Warlock_Demonology Warlock_Demonology T21 xx0x0xx',
      'T21_Warlock_Destruction Warlock_Destruction T21 xx0x0xx'
    ],
    'Warrior' => [
      'T21_Warrior_Arms Warrior_Arms T21 x3x2xxx',
      'T21_Warrior_Fury Warrior_Fury T21 x3x2xxx'
    ]
  },
  'RaceSimulation' => {
    'Death-Knight' => [
      'PR_Death_Knight_Blood',
      'PR_Death_Knight_Frost',
      'PR_Death_Knight_Unholy'
    ],
    'Demon-Hunter' => [
      'PR_Demon_Hunter_Havoc',
      'PR_Demon_Hunter_Vengeance'
    ],
    'Druid' => [
      'PR_Druid_Balance',
      'PR_Druid_Feral',
      'PR_Druid_Guardian'
    ],
    'Hunter' => [
      'PR_Hunter_Beast_Mastery',
      'PR_Hunter_Marksmanship',
      'PR_Hunter_Survival'
    ],
    'Mage' => [
      'PR_Mage_Arcane',
      'PR_Mage_Fire',
      'PR_Mage_Frost'
    ],
    'Monk' => [
      'PR_Monk_Brewmaster',
      'PR_Monk_Windwalker'
    ],
    'Paladin' => [
      'PR_Paladin_Protection',
      'PR_Paladin_Retribution'
    ],
    'Priest' => [
      'PR_Priest_Shadow'
    ],
    'Rogue' => [
      'PR_Rogue_Assassination',
      'PR_Rogue_Assassination_Exsg',
      'PR_Rogue_Outlaw',
      'PR_Rogue_Outlaw_SnD',
      'PR_Rogue_Subtlety'
    ],
    'Shaman' => [
      'PR_Shaman_Elemental',
      'PR_Shaman_Enhancement'
    ],
    'Warlock' => [
      'PR_Warlock_Affliction',
      'PR_Warlock_Demonology',
      'PR_Warlock_Destruction'
    ],
    'Warrior' => [
      'PR_Warrior_Arms',
      'PR_Warrior_Fury'
    ]
  },
  'TrinketSimulation' => {
    'Death-Knight' => [
      'PR_Death_Knight_Blood Strength',
      'PR_Death_Knight_Frost Strength',
      'PR_Death_Knight_Unholy Strength'
    ],
    'Demon-Hunter' => [
      'PR_Demon_Hunter_Havoc Agility',
      'PR_Demon_Hunter_Vengeance Agility'
    ],
    'Druid' => [
      'PR_Druid_Balance Intelligence',
      'PR_Druid_Feral Agility',
      'PR_Druid_Guardian Agility'
    ],
    'Hunter' => [
      'PR_Hunter_Beast_Mastery Agility',
      'PR_Hunter_Marksmanship Agility',
      'PR_Hunter_Survival Agility'
    ],
    'Mage' => [
      'PR_Mage_Arcane Intelligence',
      'PR_Mage_Fire Intelligence',
      'PR_Mage_Frost Intelligence'
    ],
    'Monk' => [
      'PR_Monk_Brewmaster Agility',
      'PR_Monk_Windwalker Agility'
    ],
    'Paladin' => [
      'PR_Paladin_Protection Strength',
      'PR_Paladin_Retribution Strength'
    ],
    'Priest' => [
      'PR_Priest_Shadow Intelligence'
    ],
    'Rogue' => [
      'PR_Rogue_Assassination Agility',
      'PR_Rogue_Assassination_Exsg Agility',
      'PR_Rogue_Outlaw Agility',
      'PR_Rogue_Outlaw_SnD Agility',
      'PR_Rogue_Subtlety Agility'
    ],
    'Shaman' => [
      'PR_Shaman_Elemental Intelligence',
      'PR_Shaman_Enhancement Agility'
    ],
    'Warlock' => [
      'PR_Warlock_Affliction Intelligence',
      'PR_Warlock_Demonology Intelligence',
      'PR_Warlock_Destruction Intelligence'
    ],
    'Warrior' => [
      'PR_Warrior_Arms Strength',
      'PR_Warrior_Fury Strength'
    ]
  }
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
