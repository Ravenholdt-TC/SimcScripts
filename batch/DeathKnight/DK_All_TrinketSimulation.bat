setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb DeathKnight T21_Death_Knight_Frost Melee_Strength %fightstyle% q
TrinketSimulation.rb DeathKnight T21_Death_Knight_Frost-Cold_Heart+Runic_Attenuation Melee_Strength %fightstyle% q
TrinketSimulation.rb DeathKnight T21_Death_Knight_Unholy Melee_Strength %fightstyle% q
TrinketSimulation.rb DeathKnight T21_Death_Knight_Blood Melee_Strength %fightstyle% q

REM T20
TrinketSimulation.rb DeathKnight T20_Death_Knight_Frost Melee_Strength %fightstyle% q
TrinketSimulation.rb DeathKnight T20_Death_Knight_Unholy Melee_Strength %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
