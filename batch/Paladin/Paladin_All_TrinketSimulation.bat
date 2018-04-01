setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Paladin T21_Paladin_Retribution Melee_Strength %fightstyle% q
TrinketSimulation.rb Paladin T21_Paladin_Protection Melee_Strength %fightstyle% q

REM T20
TrinketSimulation.rb Paladin T20_Paladin_Retribution Melee_Strength %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
