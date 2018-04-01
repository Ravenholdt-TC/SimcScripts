setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb DeathKnight T21_Death_Knight_Frost %fightstyle% q
RaceSimulation.rb DeathKnight T21_Death_Knight_Frost-Cold_Heart+Runic_Attenuation %fightstyle% q
RaceSimulation.rb DeathKnight T21_Death_Knight_Unholy %fightstyle% q
RaceSimulation.rb DeathKnight T21_Death_Knight_Blood %fightstyle% q

REM T20
RaceSimulation.rb DeathKnight T20_Death_Knight_Frost %fightstyle% q
RaceSimulation.rb DeathKnight T20_Death_Knight_Unholy %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
