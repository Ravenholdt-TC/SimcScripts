setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Warlock T21_Warlock_Affliction Warlock_Affliction %fightstyle% q
RelicSimulation.rb Warlock T21_Warlock_Demonology Warlock_Demonology %fightstyle% q
RelicSimulation.rb Warlock T21_Warlock_Destruction Warlock_Destruction %fightstyle% q

REM T20
RelicSimulation.rb Warlock T20_Warlock_Affliction Warlock_Affliction %fightstyle% q
RelicSimulation.rb Warlock T20_Warlock_Demonology Warlock_Demonology %fightstyle% q
RelicSimulation.rb Warlock T20_Warlock_Destruction Warlock_Destruction %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
