Mystler's SimC Scripts
======================

This repository contains my scripts for automated simulation and data collection.

## Initial Setup

Install a Ruby interpreter. On Windows you can use [RubyInstaller](https://rubyinstaller.org/).
You will need to install the DevKit as well. As of RubyInstaller 2.4+ you can run `ridk install 1 2 3`.

```
gem install bundler
bundle install
```

## General Configuration

In order to work with the scripts in this repository, copy the file `SimcConfig_Example.yml`
to `SimcConfig.yml` and change the parameters to match your setup and needs.

General simulation settings are set in `conf/SimcGlobalConfig.simc`.

If you want to access SimC default profiles, you can use the variable `$(simc_profiles_path)`
in your simc profiles.

## TrinketSimulation

Usage:
1. Create a simulation profile file in your `profiles/Templates` class folder. This file defines the
   base character to simulate.
2. (Optional) Create a custom trinket list file in the `profiles/TrinketLists`
   folder. This file defines all trinkets to simulate. (See `TrinketList_Melee_Agility.json` for
   an example.)
3. Run `TrinketSimulation.rb`. It will ask you to select the profiles.
4. Wait for the simulation to run until it says it's done.
5. The resulting CSV file will be in the `reports` folder.

The result is a CSV file containing the DPS increases for each Trinket and Item Level
compared to the Template profile.

Special Trinket simulation settings can be set in `conf/SimcTrinketConfig.simc`.

## AzeriteSimulation

Usage:
1. Create a simulation profile file in your `profiles/Templates` class folder. This file defines the
   base character to simulate.
2. Run `AzeriteSimulation.rb`. It will ask you to select the profiles.
3. Wait for the simulation to run until it says it's done.
4. The result will be two CSV files in the `reports` folder.

One file contains the DPS increases for each Trait and Item Level compared to the Template profile.
The other one has the results for multiple stacks of the traits.

Special Azerite simulation settings can be set in `conf/SimcAzeriteConfig.simc`.

## RaceSimulation

Usage:
1. Create a simulation profile file in the `profiles/Templates` folder. This file defines the
   base character to simulate.
2. Run `RaceSimulation.rb`. It will ask you to select a profile and fightstyle.
3. Wait for the simulation to run until it says it's done.
4. The resulting CSV file will be in the `reports` folder.

Special Race simulation settings can be set in `conf/SimcRaceConfig.simc`.

## Combinator

This script will run a template for whatever talent and gear combinations you would like to
investigate. It is an interactive script prompting for any input required.

All you have to do is create a `Combinator_<PROFILENAME>.simc` file in a class folder in
`profiles/Combinator`. You can also use your classes folder in `profiles/Templates`.

You can override baseline gear for certain talents setups by creating another profile in
a `TalentOverrides` subfolder. That files name has to match the profile name and a talent
permutation. (e.g. `<NAME>_xxx123x`) The same principle applies for special item overrides.
Create a `SpecialOverrides` subfolder and name it the same as the profile followed by a
special item name from the Gear file. (e.g. `<NAME>_Bracers`)

Also make sure gear and setup definitions are available. For an example, look at the
files `CombinatorGear_*.json` and `CombinatorSetups_*.json`. These
define what gear is available to the class and what setups of those to simulate.

Special Combinator simulation settings can be modified in `conf/SimcCombinatorConfig.simc`.

Then, you can run the `Combinator.rb` script.

Log files for each combination will be written to the `logs` folder. The resulting CSV
file can be found in `reports`.

## Archiver

If you run Archiver, it will automatically pack all script output files in generated, logs,
and reports into a time-stamped .tar.gz file in `archives` and delete the raw files.
