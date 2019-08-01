# This file contains lookup tables for data we use when parsing things.

ClassAndSpecIds = {
  "Warrior" => {
    class_id: 1,
    specs: {
      "arms" => 71,
      "fury" => 72,
      "protection" => 73,
    },
  },
  "Paladin" => {
    class_id: 2,
    specs: {
      "holy" => 65,
      "protection" => 66,
      "retribution" => 70,
    },
  },
  "Hunter" => {
    class_id: 3,
    specs: {
      "beast_mastery" => 253,
      "marksmanship" => 254,
      "survival" => 255,
    },
  },
  "Rogue" => {
    class_id: 4,
    specs: {
      "assassination" => 259,
      "outlaw" => 260,
      "subtlety" => 261,
    },
  },
  "Priest" => {
    class_id: 5,
    specs: {
      "discipline" => 256,
      "holy" => 257,
      "shadow" => 258,
    },
  },
  "Death-Knight" => {
    class_id: 6,
    specs: {
      "blood" => 250,
      "frost" => 251,
      "unholy" => 252,
    },
  },
  "Shaman" => {
    class_id: 7,
    specs: {
      "elemental" => 262,
      "enhancement" => 263,
      "restoration" => 264,
    },
  },
  "Mage" => {
    class_id: 8,
    specs: {
      "arcane" => 62,
      "fire" => 63,
      "frost" => 64,
    },
  },
  "Warlock" => {
    class_id: 9,
    specs: {
      "affliction" => 265,
      "demonology" => 266,
      "destruction" => 267,
    },
  },
  "Monk" => {
    class_id: 10,
    specs: {
      "brewmaster" => 268,
      "windwalker" => 269,
      "mistweaver" => 270,
    },
  },
  "Druid" => {
    class_id: 11,
    specs: {
      "balance" => 102,
      "feral" => 103,
      "guardian" => 104,
      "restoration" => 105,
    },
  },
  "Demon-Hunter" => {
    class_id: 12,
    specs: {
      "havoc" => 577,
      "vengeance" => 581,
    },
  },
}

TankSpecs = ["protection", "blood", "brewmaster", "vengeance", "guardian"]

# Map race name and simc string
RaceInputMap = {
  "Night Elf" => "night_elf",
  "Blood Elf" => "blood_elf",
  "Dwarf" => "dwarf",
  "Gnome" => "gnome",
  "Goblin" => "goblin",
  "Human" => "human",
  "Orc" => "orc",
  "Pandaren" => "pandaren",
  "Troll" => "troll",
  "Undead" => "undead",
  "Worgen" => "worgen",
  "Tauren" => "tauren",
  "Draenei" => "draenei",
  "Void Elf" => "void_elf",
  "Highmountain Tauren" => "highmountain_tauren",
  "Lightforged Draenei" => "lightforged_draenei",
  "Nightborne" => "nightborne",
  "Dark Iron Dwarf" => "dark_iron_dwarf",
  'Mag\'har Orc' => "maghar_orc",
  "Zandalari Troll" => "zandalari_troll",
  "Kul Tiran" => "kul_tiran",
}

# Map class folder and race name
ClassRaceMap = {
  "Death-Knight" => ["Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Worgen", "Orc", "Undead", "Tauren", "Troll", "Blood Elf", "Goblin"],
  "Demon-Hunter" => ["Night Elf", "Blood Elf"],
  "Druid" => ["Night Elf", "Worgen", "Tauren", "Troll", "Highmountain Tauren", "Zandalari Troll", "Kul Tiran"],
  "Hunter" => ["Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Worgen", "Lightforged Draenei", "Void Elf", "Pandaren", "Orc", "Undead", "Tauren", "Troll", "Blood Elf", "Goblin", "Highmountain Tauren", "Nightborne", "Dark Iron Dwarf", 'Mag\'har Orc', "Zandalari Troll", "Kul Tiran"],
  "Mage" => ["Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Worgen", "Lightforged Draenei", "Void Elf", "Pandaren", "Orc", "Undead", "Troll", "Blood Elf", "Goblin", "Nightborne", "Dark Iron Dwarf", 'Mag\'har Orc', "Zandalari Troll", "Kul Tiran"],
  "Monk" => ["Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Void Elf", "Pandaren", "Orc", "Undead", "Tauren", "Troll", "Blood Elf", "Highmountain Tauren", "Nightborne", "Dark Iron Dwarf", 'Mag\'har Orc', "Zandalari Troll", "Kul Tiran"],
  "Paladin" => ["Human", "Dwarf", "Draenei", "Lightforged Draenei", "Tauren", "Blood Elf", "Dark Iron Dwarf", "Zandalari Troll"],
  "Priest" => ["Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Worgen", "Lightforged Draenei", "Void Elf", "Pandaren", "Undead", "Tauren", "Troll", "Blood Elf", "Goblin", "Nightborne", "Dark Iron Dwarf", 'Mag\'har Orc', "Zandalari Troll", "Kul Tiran"],
  "Rogue" => ["Human", "Dwarf", "Night Elf", "Gnome", "Worgen", "Void Elf", "Pandaren", "Orc", "Undead", "Troll", "Blood Elf", "Goblin", "Nightborne", "Dark Iron Dwarf", 'Mag\'har Orc', "Zandalari Troll", "Kul Tiran"],
  "Shaman" => ["Dwarf", "Draenei", "Pandaren", "Orc", "Tauren", "Troll", "Goblin", "Highmountain Tauren", "Dark Iron Dwarf", 'Mag\'har Orc', "Zandalari Troll", "Kul Tiran"],
  "Warlock" => ["Human", "Dwarf", "Gnome", "Worgen", "Void Elf", "Orc", "Undead", "Troll", "Blood Elf", "Goblin", "Nightborne", "Dark Iron Dwarf"],
  "Warrior" => ["Human", "Dwarf", "Night Elf", "Gnome", "Draenei", "Worgen", "Lightforged Draenei", "Void Elf", "Pandaren", "Orc", "Undead", "Tauren", "Troll", "Blood Elf", "Goblin", "Highmountain Tauren", "Nightborne", "Dark Iron Dwarf", 'Mag\'har Orc', "Zandalari Troll", "Kul Tiran"],
}
