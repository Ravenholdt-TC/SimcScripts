Mystler's SimC Scripts
======================

This repository contains my scripts for automated simulation and data collection.

## Initial Setup

```
gem install bundler
bundle install
```

## General Configuration

In order to work with the scripts in this repository, copy the file `SimcConfig_Example.rb`
to `SimcConfig.rb` and change the parameters to match your setup and needs.

General simulation settings are set in `SimcGlobalConfig.simc`.

If you want to access SimC default profiles, you can use the variable `$(simc_profiles_path)`
in your simc profiles.

## TrinketSimulation

This documentation is based on the `RogueTrinkets.rb` simulation. If you want to simulate
other trinkets you can copy that script and rename the templates accordingly.

Usage:
1. Create a simulation profile file called `RogueTrinkets_<PROFILENAME>.simc` in the
   `profiles` folder.
   Make sure the SimC profile is named "Template".
   Make sure that `trinket1=empty` and `trinket2=empty`.
2. Run `RogueTrinkets.rb`. It will ask you to select a profile.
3. Wait for the simulation to run until it says it's done.
4. The resulting CSV and HTML file will be in the `reports` folder.

The result is a CSV file containing the DPS increases for each Trinket and Item Level
compared to the Template profile.

Special Trinket simulation settings can be set in `SimcTrinketConfig.simc`.

## RelicSimulation

Usage:
1. Create a simulation profile file called `RelicSimulation_<PROFILENAME>.simc` in the
   `profiles` folder.
   Make sure the base SimC profile is named "Template".
   Make sure you set all artifact traits to 4. (e.g. `artifact_override=master_assassin:4`)
   It may help to set the weapon item level to a predefined value. (e.g. `ilevel=900`)
2. Create additional profiles that increase weapon item level or one trait. These additional
   profile names should follow the pattern `<NAME>_<AMOUNT>` without special characters.
   (For an example look at the existing profiles in the profiles folder.)
3. Run `RelicSimulation.rb`. It will ask you to select a profile.
4. Wait for the simulation to run until it says it's done.
5. The resulting CSV and HTML file will be in the `reports` folder.

The result is a CSV file containing the DPS increases for each Relic or Relic Item Level
compared to the Template profile. Its structure has been created to fit what we import
using Google Charts on the Ravenholdt-TC website. Thus, the CSV content includes annotations
and zero values to fill for an equal amount of columns.

Special Relic simulation settings can be set in `SimcRelicConfig.simc`.

## Combinator

This script will run a template for whatever talent permutation you would like to
investigate. It is an interactive script prompting for any input required.

All you have to do is create a `Combinator_<PROFILENAME>.simc` file in `profiles` with
your profile and the line:
```
talents=$(tbuild)
```

Also, you should add `$(tbuild)` to the profile name(s).

Special Combinator simulation settings can be modified in `SimcCombinatorConfig.simc`.

Then, you can run the `Combinator.rb` script.

Log files for each combination will be written to the `logs` folder. The resulting CSV
file can be found in `reports`.

Since we upload some results to a website for display, I created another
script for better CSV column splitting. Just head into the `reports` folder and
drag and drop the `Combinator_<PROFILENAME>.csv` file onto `CombinatorColumnSplit.bat`.
