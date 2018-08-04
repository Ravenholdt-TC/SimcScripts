# This file contains lookup tables for data we use when parsing things.

ClassAndSpecIds = {
  'Warrior' => {
    class_id: 1,
    specs: {
      'Arms' => 71,
      'Fury' => 72,
      'Protection' => 73,
    },
  },
  'Paladin' => {
    class_id: 2,
    specs: {
      'Holy' => 65,
      'Protection' => 66,
      'Retribution' => 70,
    },
  },
  'Hunter' => {
    class_id: 3,
    specs: {
      'Beast-Mastery' => 253,
      'Marksmanship' => 254,
      'Survival' => 255,
    },
  },
  'Rogue' => {
    class_id: 4,
    specs: {
      'Assassination' => 259,
      'Outlaw' => 260,
      'Subtlety' => 261,
    },
  },
  'Priest' => {
    class_id: 5,
    specs: {
      'Discipline' => 256,
      'Holy' => 257,
      'Shadow' => 258,
    },
  },
  'Death-Knight' => {
    class_id: 6,
    specs: {
      'Blood' => 250,
      'Frost' => 251,
      'Unholy' => 252,
    },
  },
  'Shaman' => {
    class_id: 7,
    specs: {
      'Elemental' => 262,
      'Enhancement' => 263,
      'Restoration' => 264,
    },
  },
  'Mage' => {
    class_id: 8,
    specs: {
      'Arcane' => 62,
      'Fire' => 63,
      'Frost' => 64,
    },
  },
  'Warlock' => {
    class_id: 9,
    specs: {
      'Affliction' => 265,
      'Demonology' => 266,
      'Destruction' => 267,
    },
  },
  'Monk' => {
    class_id: 10,
    specs: {
      'Brewmaster' => 268,
      'Windwalker' => 269,
      'Mistweaver' => 270,
    },
  },
  'Druid' => {
    class_id: 11,
    specs: {
      'Balance' => 102,
      'Feral' => 103,
      'Guardian' => 104,
    },
    'Restoration' => 105,
  },
  'Demon-Hunter' => {
    class_id: 12,
    specs: {
      'Havoc' => 577,
      'Vengeance' => 581,
    },
  },
}

# Map race name and simc string
RaceInputMap = {
  'Night Elf' => 'night_elf',
  'Blood Elf' => 'blood_elf',
  'Dwarf' => 'dwarf',
  'Gnome' => 'gnome',
  'Goblin' => 'goblin',
  'Human' => 'human',
  'Orc' => 'orc',
  'Pandaren' => 'pandaren',
  'Troll' => 'troll',
  'Undead' => 'undead',
  'Worgen' => 'worgen',
  'Tauren' => 'tauren',
  'Draenei' => 'draenei',
  'Void Elf' => 'void_elf',
  'Highmountain Tauren' => 'highmountain_tauren',
  'Lightforged Draenei' => 'lightforged_draenei',
  'Nightborne' => 'nightborne',
###### BfA
#'Zandalari Troll' => 'zandalari_troll',
#'Dark Iron Dwarf' => 'dark_iron_dwarf'
}

# Map class folder and race name
ClassRaceMap = {
  'Death-Knight' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Orc', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Goblin'],
  'Demon-Hunter' => ['Night Elf', 'Blood Elf'],
  'Druid' => ['Night Elf', 'Worgen', 'Tauren', 'Troll', 'Highmountain Tauren'],
  'Hunter' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Lightforged Draenei', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Goblin', 'Highmountain Tauren', 'Nightborne'],
  'Mage' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Lightforged Draenei', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Troll', 'Blood Elf', 'Goblin', 'Nightborne'],
  'Monk' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Highmountain Tauren', 'Nightborne'],
  'Paladin' => ['Human', 'Dwarf', 'Draenei', 'Lightforged Draenei', 'Tauren', 'Blood Elf'],
  'Priest' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Lightforged Draenei', 'Void Elf', 'Pandaren', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Goblin', 'Nightborne'],
  'Rogue' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Worgen', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Troll', 'Blood Elf', 'Goblin', 'Nightborne'],
  'Shaman' => ['Dwarf', 'Draenei', 'Pandaren', 'Orc', 'Tauren', 'Troll', 'Goblin', 'Highmountain Tauren'],
  'Warlock' => ['Human', 'Dwarf', 'Gnome', 'Worgen', 'Void Elf', 'Orc', 'Undead', 'Troll', 'Blood Elf', 'Goblin', 'Nightborne'],
  'Warrior' => ['Human', 'Dwarf', 'Night Elf', 'Gnome', 'Draenei', 'Worgen', 'Lightforged Draenei', 'Void Elf', 'Pandaren', 'Orc', 'Undead', 'Tauren', 'Troll', 'Blood Elf', 'Goblin', 'Highmountain Tauren', 'Nightborne'],
}
