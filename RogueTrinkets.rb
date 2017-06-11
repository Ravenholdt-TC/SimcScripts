Template = File.basename(__FILE__, ".rb")
ItemLevels = [900, 905, 910, 915, 920, 925, 930, 935, 940, 945, 950, 955]
TrinketIDs = {
  "DraughtOfSouls" => 140808,
  "ConvergenceOfFates" => 140806,
  "EntwinedElementalFoci" => 140796,
  "NightbloomingFrond" => 140802,
  "ArcanogolemDigit" => 140794,
  "RavagedSeedPod" => 139320,
  "SpontaneousAppendages" => 139325,
  "NaturesCall" => 139334,
  "BloodthirstyInstict" => 139329,
  "EyeOfCommand" => 142167,
  "ChaosTalisman" => 137459,
  "EyeOfGuarm_Mastery" => 142506,
  "EyeOfGuarm_Versatility" => 142506,
  "EyeOfGuarm_Haste" => 142506,
  "EyeOfGuarm_Crit" => 142506,
  "EtherealUrn" => 142166,
  "UnstableArcanocrystal" => 141482,
  "TirathonsBetrayal" => 137537,
  "SixFeatherFan" => 141585,
  "ChronoShard" => 137419,
  "ThriceAccursedCompass" => 141537,
  "WindscarWhetstone" => 137486,
  "BloodstainedHandkerchief" => 142159,
  "SpikedCounterweight" => 136715,
  "NightmareEggShell" => 137312,
  "TemperedEggOfSerpentrix" => 137373,
  "HornOfValor" => 133642,
  "HungerOfThePack" => 136975,
  "MementoOfAngerboda" => 133644,
  "MarkOfDargrul" => 137357,
  "TerrorboundNexus" => 137406,
  "FaultyCountermeasure" => 137539,
  "ToeKneesPromise" => 142164,
  "TinyOozelingInAJar" => 137439,
  "DevilsaursBite" => 140026,
  "SpecterOfBetrayal" => 151190,
  "EngineOfEradication" => 147015,
  "UmbralMoonglaives" => 147012,
  "VialOfCeaselessToxins" => 147011,
  "InfernalCinders" => 147009
}
BonusIDs = {
  "EyeOfGuarm_Mastery" => 605,
  "EyeOfGuarm_Versatility" => 607,
  "EyeOfGuarm_Haste" => 604,
  "EyeOfGuarm_Crit" => 603
}

require_relative 'TrinketSimulation'
CalculateTrinkets()
