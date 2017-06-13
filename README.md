Mystler's SimC Scripts
======================

This repository contains my scripts for automated simulation and data collection.
There is a general assumption that these scripts are run from within a `scripts`
directory inside the SimulationCraft folder.

## TrinketSimulation

Usage:
1. Create a simulation profile file for your character called
   `{PROFILE}_Template.simc`.
   Make sure the profile is named "Template".
   Make sure that `trinket1=empty` and `trinket2=empty`.
   (You copy RogueTrinkets_Template.simc and modify.)
2. Create a Ruby file that sets the required constants for this file called
   `{PROFILE}.rb`.
   (You copy RogueTrinkets.rb and modify.)
3. Run the ruby file created in step 2, e.g. by double clicking on it.

Requires constants Template, ItemLevels, TrinketIDs and (optionally) BonusIDs to be set.

The result is a CSV file containing the DPS increases for each Trinket and Item Level
compared to the Template profile.

## Combinator

This script will run a template for whatever talent permutation you would like to
investigate. It is an interactive script prompting for any input required.

All you have to do is create a `Combinator_<PROFILENAME>.simc` template with talents
(and probably part of the profile names as well) replaced with `$(tbuild)`.

General simulation settings (like target error or the number of threads) can be modified
in `CombinatorConfig.simc`.

Then you can run the `Combinator.rb` script.

Since I upload the results into a Google spreadsheet for display, I created another
script for better CSV column splitting as well. Just drag and drop the `Combinator.csv`
file onto the `CombinatorColumnSplit.bat` file.
