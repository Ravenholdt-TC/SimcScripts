# This script was used to extract metadata when it was implemented for already simmed profiles.
# It's a one-use script as you see, so not very optimized (as most of the scripts in this folder).
# It'll likely no longer work in the future as we improve our lib.

require 'rubygems'
require 'bundler/setup'
require_relative 'lib/Interactive'
require_relative 'lib/JSONParser'

# Extract meta datas
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/Combinator_1T_T21_Hunter_Beast_Mastery_CoF.json", "#{SimcConfig::ReportsFolder}/meta/Combinator_1T_T21_Hunter_Beast_Mastery_CoF.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/Combinator_1T_T21_Hunter_Beast_Mastery_Crit.json", "#{SimcConfig::ReportsFolder}/meta/Combinator_1T_T21_Hunter_Beast_Mastery_Crit.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/Combinator_1T_T21_Hunter_Beast_Mastery.json", "#{SimcConfig::ReportsFolder}/meta/Combinator_1T_T21_Hunter_Beast_Mastery.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/Combinator_1T_T21_Hunter_Marksmanship.json", "#{SimcConfig::ReportsFolder}/meta/Combinator_1T_T21_Hunter_Marksmanship.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T19_Rogue_Assassination.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T19_Rogue_Assassination.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T19_Rogue_Outlaw.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T19_Rogue_Outlaw.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T19_Rogue_Subtlety.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T19_Rogue_Subtlety.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T20_Rogue_Assassination_Exsg.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T20_Rogue_Assassination_Exsg.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T20_Rogue_Assassination.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T20_Rogue_Assassination.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T20_Rogue_Outlaw_SnD.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T20_Rogue_Outlaw_SnD.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T20_Rogue_Outlaw.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T20_Rogue_Outlaw.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T20_Rogue_Subtlety_DfA.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T20_Rogue_Subtlety_DfA.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T20_Rogue_Subtlety.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T20_Rogue_Subtlety.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Hunter_Beast_Mastery.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Hunter_Beast_Mastery.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Hunter_Marksmanship.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Hunter_Marksmanship.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Hunter_Survival.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Hunter_Survival.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Rogue_Assassination_Exsg.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Rogue_Assassination_Exsg.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Rogue_Assassination.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Rogue_Assassination.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Rogue_Outlaw_SnD.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Rogue_Outlaw_SnD.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Rogue_Outlaw.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Rogue_Outlaw.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Rogue_Subtlety_DfA.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Rogue_Subtlety_DfA.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/RelicSimulation_1T_T21_Rogue_Subtlety.json", "#{SimcConfig::ReportsFolder}/meta/RelicSimulation_1T_T21_Rogue_Subtlety.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T19_Rogue_Assassination.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T19_Rogue_Assassination.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T19_Rogue_Outlaw.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T19_Rogue_Outlaw.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T19_Rogue_Subtlety.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T19_Rogue_Subtlety.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T20_Rogue_Assassination_Exsg.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T20_Rogue_Assassination_Exsg.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T20_Rogue_Assassination.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T20_Rogue_Assassination.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T20_Rogue_Outlaw_SnD.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T20_Rogue_Outlaw_SnD.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T20_Rogue_Outlaw.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T20_Rogue_Outlaw.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T20_Rogue_Subtlety_DfA.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T20_Rogue_Subtlety_DfA.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T20_Rogue_Subtlety.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T20_Rogue_Subtlety.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Hunter_Beast_Mastery.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Hunter_Beast_Mastery.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Hunter_Marksmanship.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Hunter_Marksmanship.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Hunter_Survival.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Hunter_Survival.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Paladin_Retribution.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Paladin_Retribution.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Rogue_Assassination_Exsg.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Rogue_Assassination_Exsg.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Rogue_Assassination.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Rogue_Assassination.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Rogue_Outlaw_SnD.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Rogue_Outlaw_SnD.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Rogue_Outlaw.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Rogue_Outlaw.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Rogue_Subtlety_DfA.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Rogue_Subtlety_DfA.json")
# JSONParser.ExtractMetadata("#{SimcConfig::LogsFolder}/TrinketSimulation_1T_T21_Rogue_Subtlety.json", "#{SimcConfig::ReportsFolder}/meta/TrinketSimulation_1T_T21_Rogue_Subtlety.json")

puts 'Done! Press enter to quit...'
Interactive.GetInputOrArg()
