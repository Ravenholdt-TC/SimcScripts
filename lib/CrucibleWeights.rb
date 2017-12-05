module CrucibleWeights
  def self.GetCrucibleWeightString(spec_string, results, templateDPS)
    unless WeaponMap[spec_string]
      puts "ERROR: #{spec_string} not found in WeaponMap. Not creating crucible weight string."
      return nil
    end
    unless TraitMap[spec_string]
      puts "ERROR: #{spec_string} not found in TraitMap. Not creating crucible weight string."
      return nil
    end
    unless results['WeaponItemLevel']
      puts "ERROR: WeaponItemLevel not found in results. Not creating crucible weight string."
      return nil
    end
    cruweight = "cruweight^#{WeaponMap[spec_string]}^ilvl^1^"
    results.each do |name, values|
      next if name == "WeaponItemLevel"
      if TraitMap[spec_string][name]
        traitId = TraitMap[spec_string][name]
        cruweight += "#{traitId}^"
        ranks = []
        values.sort.each do |amount, dps|
          prevRankDPS = amount - 1 > 0 ? values[amount - 1] : templateDPS
          weight = (dps.to_f - prevRankDPS) / (results['WeaponItemLevel'][1].to_f - templateDPS)
          ranks.push("#{amount + 4}:#{weight.round(2)}")
        end
        cruweight += ranks.join(' ') + '^'
      elsif TraitMap['Crucible'][name]
        traitId = TraitMap['Crucible'][name]
        weight = (values[1].to_f - templateDPS) / (results['WeaponItemLevel'][1].to_f - templateDPS)
        cruweight += "#{traitId}^#{weight.round(2)}^"
      else
        puts "WARNING: No spell id for trait #{name} found. Ignoring in crucible weight string."
        next
      end
    end
    cruweight += 'end'
    return cruweight
  end

  WeaponMap = {
    'Blood Death Knight' => 128402,
    'Frost Death Knight' => 128292,
    'Unholy Death Knight' => 128403,

    'Havoc Demon Hunter' => 127829,
    'Vengeance Demon Hunter' => 128832,

    'Balance Druid' => 128858,
    'Feral Druid' => 128860,
    'Guardian Druid' => 128821,
    'Restoration Druid' => 128306,

    'Beast Mastery Hunter' => 128861,
    'Marksmanship Hunter' => 128826,
    'Survival Hunter' => 128808,

    'Arcane Mage' => 127857,
    'Fire Mage' => 128820,
    'Frost Mage' => 128862,

    'Brewmaster Monk' => 128938,
    'Mistweaver Monk' => 128937,
    'Windwalker Monk' => 128940,

    'Holy Paladin' => 128823,
    'Protection Paladin' => 128866,
    'Retribution Paladin' => 120978,

    'Discipline Priest' => 128868,
    'Holy Priest' => 128825,
    'Shadow Priest' => 128827,

    'Assassination Rogue' => 128870,
    'Outlaw Rogue' => 128872,
    'Subtlety Rogue' => 128476,

    'Elemental Shaman' => 128935,
    'Enhancement Shaman' => 128819,
    'Restoration Shaman' => 128911,

    'Affliction Warlock' => 128942,
    'Demonology Warlock' => 128943,
    'Destruction Warlock' => 128941,

    'Arms Warrior' => 128910,
    'Fury Warrior' => 128908,
    'Protection Warrior' => 128289
  }

  TraitMap = {
    'Crucible' => {
      #Crucible Shadow
      'MasterOfShadows' => 252091,
      'MurderousIntent' => 252191,
      'Shadowbind' => 252875,
      'ChaoticDarkness' => 252888,
      'TormentTheWeak' => 252906,
      'DarkSorrows' => 252922,
      #Crucible Light
      'LightSpeed' => 252088,
      'RefractiveShell' => 252207,
      'Shocklight' => 252799,
      'SecureInTheLight' => 253070,
      'InfusionOfLight' => 253093,
      'LightsEmbrace' => 253111
    },

    'Blood Death Knight' => {
      'AllconsumingRot' => 192464,
      'Bonebreaker' => 192538,
      'CarrionFest' => 238042,
      'Coagulopathy' => 192460,
      'DanceOfDarkness' => 192514,
      'GrimPerseverance' => 192447,
      'IronHeart' => 192450,
      'MeatShield' => 192453,
      'VampiricFangs' => 192542,
      'Veinrender' => 192457
    },

    'Frost Death Knight' => {
      'Ambidexterity' => 189092,
      'BadToTheBone' => 189147,
      'BlastRadius' => 189086,
      'ColdAsIce' => 189080,
      'DeadOfWinter' => 189164,
      'FrozenSkin' => 204875,
      'IceInYourVeins' => 189154,
      'NothingButTheBoots' => 189144,
      'OverPowered' => 189097,
      'Runefrost' => 238043
    },

    'Unholy Death Knight' => {
      'DeadliestCoil' => 191419,
      'DeadlyDurability' => 191565,
      'EternalAgony' => 208598,
      'LashOfShadows' => 238044,
      'Plaguebearer' => 191485,
      'RottenTouch' => 191442,
      'RunicTattoos' => 191592,
      'ScourgeTheUnbeliever' => 191494,
      'TheDarkestCrusade' => 191488,
      'UnholyEndurance' => 191584
    },

    'Havoc Demon Hunter' => {
      'ContainedFury' => 201454,
      'CriticalChaos' => 201455,
      'ChaosVision' => 201456,
      'SharpenedGlaives' => 201457,
      'DemonRage' => 201458,
      'IllidariKnowledge' => 201459,
      'UnleashedDemons' => 201460,
      'DeceiversFury' => 201463,
      'OverwhelmingPower' => 201464,
      'WideEyes' => 238045
    },

    #TODO
    'Vengeance Demon Hunter' => {
    },

    'Balance Druid' => {
      'BladedFeathers' => 202302,
      'TouchOfTheMoon' => 203018,
      'DarkSideOfTheMoon' => 202384,
      'TwilightGlow' => 202386,
      'SolarStabbing' => 202426,
      'ScytheOfTheStars' => 202433,
      'FallingStar' => 202445,
      'SunfireBurns' => 202466,
      'Empowerment' => 202464,
      'LightOfTheEveningStar' => 238047
    },

    'Feral Druid' => {
      'HonedInstincts' => 210557,
      'RazorFangs' => 210570,
      'FeralPower' => 210571,
      'PowerfulBite' => 210575,
      'AshamanesEnergy' => 210579,
      'AttunedToNature' => 210590,
      'TearTheFlesh' => 210593,
      'FeralInstinct' => 210631,
      'SharpenedClaws' => 210637,
      'ThrashingClaws' => 238048
    },

    #TODO
    'Guardian Druid' => {
    },

    #TODO
    'Restoration Druid' => {
    },

    'Beast Mastery Hunter' => {
      'WildernessExpert' => 197038,
      'FuriousSwipes' => 197047,
      'PackLeader' => 197080,
      'NaturalReflexes' => 197138,
      'FocusOfTheTitans' => 197139,
      'SpittingCobras' => 197140,
      'MimironsShell' => 197160,
      'JawsOfThunder' => 197162,
      'UnleashTheBeast' => 206910,
      'SlitheringSerpents' => 238051
    },

    'Marksmanship Hunter' => {
      'DeadlyAim' => 190449,
      'WindrunnersGuidance' => 190457,
      'QuickShot' => 190462,
      'CalledShot' => 190467,
      'HealingShell' => 190503,
      'SurvivalOfTheFittest' => 190514,
      'Precision' => 190520,
      'MarkedForDeath' => 190529,
      'GustOfWind' => 190567,
      'UnerringArrows' => 238052
    },

    'Survival Hunter' => {
      'SharpenedFang' => 203566,
      'MyBelovedMonster' => 203577,
      'LaceratingTalons' => 203578,
      'RaptorsCry' => 203638,
      'FluffyGo' => 203669,
      'ExplosiveForce' => 203670,
      'Hellcarver' => 203673,
      'BirdOfPrey' => 224764,
      'HuntersBounty' => 203749,
      'JawsOfTheMongoose' => 238053
    },

    'Arcane Mage' => {
      'TorrentialBarrage' => 187304,
      'BlastingRod' => 187258,
      'AegwynnsWrath' => 187321,
      'ArcanePurification' => 187313,
      'AegwynnsFury' => 187287,
      'EtherealSensitivity' => 187276,
      'AegwynnsImperative' => 187264,
      'EverywhereAtOnce' => 187301,
      'ForceBarrier' => 210716,
      'AegwynnsIntensity' => 238054
    },

    'Fire Mage' => {
      'FireAtWill' => 194224,
      'ReignitionOverdrive' => 194234,
      'PyroclasmicParanoia' => 194239,
      'BurningGaze' => 194312,
      'BlueFlameSpecial' => 210182,
      'GreatBallsOfFire' => 194313,
      'EverburningConsumption' => 194314,
      'CauterizingBlink' => 194318,
      'MoltenSkin' => 194315,
      'PreIgnited' => 238055
    },

    'Frost Mage' => {
      'IcyCaress' => 195315,
      'IceAge' => 195317,
      'LetItGo' => 195322,
      'OrbitalStrike' => 195323,
      'FrozenVeins' => 195345,
      'ClarityOfThought' => 195351,
      'TheStormRages' => 195352,
      'ShieldOfAlodi' => 195354,
      'Jouster' => 214626,
      'ObsidianLance' => 238056
    },

    #TODO
    'Brewmaster Monk' => {},

    #TODO
    'Mistweaver Monk' => {},

    'Windwalker Monk' => {
      'InnerPeace' => 195243,
      'LightOnYourFeet' => 195244,
      'RisingWinds' => 195263,
      'TigerClaws' => 218607,
      'DeathArt' => 195266,
      'PowerOfAThousandCranes' => 195269,
      'FistsOfTheWind' => 195291,
      'HealingWinds' => 195380,
      'StrengthOfXuen' => 195267,
      'SplitPersonality' => 238059
    },

    #TODO
    'Protection Paladin' => {},

    #TODO
    'Holy Paladin' => {},

    'Retribution Paladin' => {
      'HighlordsJudgement' => 186941,
      'SharpenedEdge' => 184759,
      'RighteousBlade' => 184843,
      'EmbraceTheLight' => 186934,
      'Deflection' => 184778,
      'DeliverTheJustice' => 186927,
      'MightOfTheTemplar' => 185368,
      'ProtectorOfTheAshenBlade' => 186944,
      'WrathOfTheAshbringer' => 186945,
      'RighteousVerdict' => 238062
    },

    #TODO
    'Holy Priest' => {},

    #TODO
    'Discipline Priest' => {},

    'Shadow Priest' => {
      'UnleashTheShadows' => 194093,
      'FromTheShadows' => 193642,
      'MindShattering' => 193643,
      'ToThePain' => 193644,
      'DeathsEmbrace' => 193645,
      'ThoughtsOfInsanity' => 193647,
      'CreepingShadows' => 194002,
      'TouchOfDarkness' => 194007,
      'VoidCorruption' => 194016,
      'FiendingDark' => 238065
    },

    'Assassination Rogue' => {
      'ToxicBlades' => 192310,
      'SerratedEdge' => 192315,
      'MasterAlchemist' => 192318,
      'FadeIntoShadows' => 192323,
      'BalancedBlades' => 192326,
      'GushingWound' => 192329,
      'ShadowWalker' => 192345,
      'MasterAssassin' => 192349,
      'PoisonKnives' => 192376,
      'Strangler' => 238066
    },

    'Outlaw Rogue' => {
      'BlackPowder' => 216230,
      'BladeDancer' => 202507,
      'FatesThirst' => 202514,
      'FortunesStrike' => 202521,
      'Gunslinger' => 202522,
      'Fatebringer' => 202524,
      'FortuneStrikes' => 202530,
      'GhostlyShell' => 202533,
      'FortunesBoon' => 202907,
      'Sabermetrics' => 238067
    },

    'Subtlety Rogue' => {
      'TheQuietKnife' => 197231,
      'DemonsKiss' => 197233,
      'Gutripper' => 197234,
      'PrecisionStrike' => 197235,
      'FortunesBite' => 197369,
      'SoulShadows' => 197386,
      'EnergeticStabbing' => 197239,
      'CatlikeReflexes' => 197241,
      'GhostArmor' => 197244,
      'WeakPoint' => 238068
    },

    'Elemental Shaman' => {
      'CallOfThunder' => 191493,
      'TheGroundTrembles' => 191499,
      'LavaImbued' => 191504,
      'Firestorm' => 191740,
      'ProtectionOfTheElements' => 191569,
      'MoltenBlast' => 191572,
      'ElectricDischarge' => 191577,
      'ShamanisticHealing' => 191582,
      'EarthenAttunement' => 191598,
      'ElementalDestabilization' => 238069
    },

    'Enhancement Shaman' => {
      'WeaponsOfTheElements' => 215381,
      'ForgedInLava' => 198236,
      'SpiritOfTheMaelstrom' => 198238,
      'WindSurge' => 198247,
      'ElementalHealing' => 198248,
      'WindStrikes' => 198292,
      'SpiritualHealing' => 198296,
      'GatheringStorms' => 198299,
      'GatheringOfTheMaelstrom' => 198349,
      'CrashingHammer' => 238070
    },

    #TODO
    'Restoration Shaman' => {},

    'Affliction Warlock' => {
      'InimitableAgony' => 199111,
      'HideousCorruption' => 199112,
      'DrainedToAHusk' => 199120,
      'InherentlyUnstable' => 199152,
      'SeedsOfDoom' => 199153,
      'Perdition' => 199158,
      'ShadowyIncantations' => 199163,
      'ShadowsOfTheFlesh' => 199212,
      'LongDarkNightOfTheSoul' => 199214,
      'Winnowing' => 238072
    },

    'Demonology Warlock' => {
      'SummonersProwess' => 211108,
      'Legionwrath' => 211126,
      'TheDoomOfAzeroth' => 211106,
      'SharpenedDreadfangs' => 211123,
      'DirtyHands' => 211105,
      'InfernalFurnace' => 211119,
      'MawOfShadows' => 211099,
      'OpenLink' => 211144,
      'FirmResolve' => 211131,
      'LeftHandOfDarkness' => 238073
    },

    'Destruction Warlock' => {
      'MasterOfDisaster' => 196211,
      'ChaoticInstability' => 196217,
      'FireAndTheFlames' => 196222,
      'ResidualFlames' => 196227,
      'Soulsnatcher' => 196236,
      'BurningHunger' => 196432,
      'FireFromTheSky' => 196258,
      'DevourerOfLife' => 196301,
      'EternalStruggle' => 196305,
      'FlamesOfSargeras' => 238074
    },

    #TODO
    'Protection Warrior' => {},

    'Arms Warrior' => {
      'UnendingRage' => 209459,
      'OneAgainstMany' => 209462,
      'CrushingBlows' => 209472,
      'ManyWillFall' => 216274,
      'Deathblow' => 209481,
      'TacticalAdvance' => 209483,
      'PreciseStrikes' => 248579,
      'ExloitTheWeakness' => 209494,
      'TouchOfZakajz' => 209541,
      'StormOfSwords' => 238075
    },

    'Fury Warrior' => {
      'Deathdealer' => 200846,
      'WildSlashes' => 216273,
      'WrathAndFury' => 200849,
      'Unstoppable' => 200853,
      'UncontrolledRage' => 200856,
      'BattleScars' => 200857,
      'Bloodcraze' => 200859,
      'UnrivaledStrength' => 200860,
      'RagingBerserker' => 200861,
      'PulseOfBattle' => 238076
    }
  }
end
