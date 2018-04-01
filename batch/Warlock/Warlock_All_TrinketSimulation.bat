setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Warlock T21_Warlock_Affliction Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Warlock T21_Warlock_Demonology Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Warlock T21_Warlock_Destruction Ranged_Intelligence %fightstyle% q

REM T20
TrinketSimulation.rb Warlock T20_Warlock_Affliction Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Warlock T20_Warlock_Demonology Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Warlock T20_Warlock_Destruction Ranged_Intelligence %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
