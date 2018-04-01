setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Warrior T21_Warrior_Arms Melee_Strength %fightstyle% q
TrinketSimulation.rb Warrior T21_Warrior_Fury Melee_Strength %fightstyle% q

REM T20
TrinketSimulation.rb Warrior T20_Warrior_Arms Melee_Strength %fightstyle% q
TrinketSimulation.rb Warrior T20_Warrior_Fury Melee_Strength %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
