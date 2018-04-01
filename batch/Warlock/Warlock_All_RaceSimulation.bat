setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb Warlock T21_Warlock_Affliction %fightstyle% q
RaceSimulation.rb Warlock T21_Warlock_Demonology %fightstyle% q
RaceSimulation.rb Warlock T21_Warlock_Destruction %fightstyle% q

REM T20
RaceSimulation.rb Warlock T20_Warlock_Affliction %fightstyle% q
RaceSimulation.rb Warlock T20_Warlock_Demonology %fightstyle% q
RaceSimulation.rb Warlock T20_Warlock_Destruction %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
