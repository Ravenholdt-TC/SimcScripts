setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb DeathKnight T21_Death_Knight_Frost Death_Knight_Frost %fightstyle% q
RelicSimulation.rb DeathKnight T21_Death_Knight_Frost-Cold_Heart+Runic_Attenuation Death_Knight_Frost %fightstyle% q
RelicSimulation.rb DeathKnight T21_Death_Knight_Unholy Death_Knight_Unholy %fightstyle% q
RelicSimulation.rb DeathKnight T21_Death_Knight_Blood Death_Knight_Blood %fightstyle% q

REM T20
RelicSimulation.rb DeathKnight T20_Death_Knight_Frost Death_Knight_Frost %fightstyle% q
RelicSimulation.rb DeathKnight T20_Death_Knight_Unholy Death_Knight_Unholy %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
