setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Monk T21_Monk_Windwalker Melee_Agility %fightstyle% q
TrinketSimulation.rb Monk T21_Monk_Brewmaster Melee_Agility %fightstyle% q

REM T20
TrinketSimulation.rb Monk T20_Monk_Windwalker Melee_Agility %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
