Mystler's SimC Scripts
======================

This repository contains my scripts for automated simulation and data collection.

## Initial Setup

Install a Ruby interpreter. On Windows you can use [RubyInstaller](https://rubyinstaller.org/).
You will need to install the DevKit as well. As of RubyInstaller 2.4+ you can run `ridk install 123`.

```
gem install bundler
bundle install
```

## General Configuration

In order to work with the scripts in this repository, copy the file `SimcConfig_Example.yml`
to `SimcConfig.yml` and change the parameters to match your setup and needs.

General simulation settings are set in `SimcGlobalConfig.simc`.

If you want to access SimC default profiles, you can use the variable `$(simc_profiles_path)`
in your simc profiles.

## TrinketSimulation

Usage:
1. Create a base simulation profile file called `TrinketSimulation_<PROFILENAME>.simc` in the
   `profiles/TrinketSimulation` folder. This file defines the base character to simulate.
2. (Optional) Create a custom trinket list file called `TrinketList_<NAME>.json` in the profiles
   folder. This file defines all trinkets to simulate. (See `TrinketList_Melee_Agility.json` for
   an example.)
3. Run `TrinketSimulation.rb`. It will ask you to select the profiles.
4. Wait for the simulation to run until it says it's done.
5. The resulting CSV file will be in the `reports` folder.

The result is a CSV file containing the DPS increases for each Trinket and Item Level
compared to the Template profile.

Special Trinket simulation settings can be set in `SimcTrinketConfig.simc`.

## RelicSimulation

Usage:
1. Create a simulation profile file called `RelicSimulation_<PROFILENAME>.simc` in the
   `profiles/RelicSimulation` folder.
2. Run `RelicSimulation.rb`. It will ask you to select a profile and spec.
3. Wait for the simulation to run until it says it's done.
4. The resulting CSV file will be in the `reports` folder.

The relics used for the simulationa are configured in `profiles/RelicSimulation/RelicList.json`.

The crucible weight string can be found in the terminal output and in the meta report file
at the bottom.

The result is a CSV file containing the DPS increases for each Relic or Relic Item Level
compared to the Template profile. Its structure has been created to fit what we import
using Google Charts on the Ravenholdt-TC/HeroDamage website. Thus, the CSV content includes
annotations and zero values to fill for an equal amount of columns.

Special Relic simulation settings can be set in `SimcRelicConfig.simc`.

## Combinator

This script will run a template for whatever talent and gear combinations you would like to
investigate. It is an interactive script prompting for any input required.

All you have to do is create a `Combinator_<PROFILENAME>.simc` file in a class folder in
`profiles/Combinator` with the baseline profile called "Template".

You can override baseline gear for certain talents setups by creating another profile in
a `TalentOverrides` subfolder. That files name has to match the profile name and a talent
permutation. (e.g. `<NAME>_xxx123x`) The same principle applies for legendary overrides.
Create a `LegendaryOverrides` subfolder and name it same as the profile followed by a
legendary name from the Gear file. (e.g. `<NAME>_Bracers`)

Also make sure gear and setup definitions are available. For an example, look at the
files `CombinatorGear_*.json` and `CombinatorSetups_*.json`. These
define what gear is available to the class and what setups of those to simulate.

Special Combinator simulation settings can be modified in `SimcCombinatorConfig.simc`.

Then, you can run the `Combinator.rb` script.

Log files for each combination will be written to the `logs` folder. The resulting CSV
file can be found in `reports`.

## Archiver

If you run Archiver, it will automatically pack all script output files in generated, logs,
and reports into a time-stamped .tar.gz file in `archives` and delete the raw files.
