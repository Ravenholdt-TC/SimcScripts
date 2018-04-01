setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Shaman T21_Shaman_Elemental Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Shaman T21_Shaman_Enhancement Melee_Agility %fightstyle% q

REM T20
TrinketSimulation.rb Shaman T20_Shaman_Elemental Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Shaman T20_Shaman_Enhancement Melee_Agility %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
