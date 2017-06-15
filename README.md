Mystler's SimC Scripts
======================

This repository contains my scripts for automated simulation and data collection.

## General Configuration

In order to work with the scripts in this repository, copy the file `SimcConfig_Example.rb`
to `SimcConfig.rb` and change the parameters to match your setup and needs.

General simulation settings are set in `SimcGlobalConfig.simc`.

## TrinketSimulation

This documentation is based on the `RogueTrinkets.rb` simulation. If you want to simulate
other trinkets you can copy that script and rename the templates accordingly.

Usage:
1. Create a simulation profile file called `RogueTrinkets_<PROFILENAME>.simc`.
   Make sure the SimC profile is named "Template".
   Make sure that `trinket1=empty` and `trinket2=empty`.
2. Run `RogueTrinkets.rb`. It will ask you to select a profile.
3. Wait for the simulation to run until it says it's done.
3. The resulting CSV and HTML file will be in the `reports` folder.

The result is a CSV file containing the DPS increases for each Trinket and Item Level
compared to the Template profile.

Special Trinket simulation settings can be set in `SimcTrinketConfig.simc`.

## Combinator

This script will run a template for whatever talent permutation you would like to
investigate. It is an interactive script prompting for any input required.

All you have to do is create a `Combinator_<PROFILENAME>.simc` template with the line:
```
talents=$(tbuild)
```

Also, you should add `$(tbuild)` to the profile name(s).

Special Combinator simulation settings can be modified in `SimcCombinatorConfig.simc`.

Then, you can run the `Combinator.rb` script.

Log files for each combination will be written to the `logs` folder. The resulting CSV
file can be found in `reports`.

Since I upload the results into a Google spreadsheet for display, I created another
script for better CSV column splitting as well. Just drag and drop the `Combinator.csv`
file onto the `CombinatorColumnSplit.bat` file.
