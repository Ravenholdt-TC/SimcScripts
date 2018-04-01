setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Warrior T21_Warrior_Arms Warrior_Arms %fightstyle% q
RelicSimulation.rb Warrior T21_Warrior_Fury Warrior_Fury %fightstyle% q

REM T20
RelicSimulation.rb Warrior T20_Warrior_Arms Warrior_Arms %fightstyle% q
RelicSimulation.rb Warrior T20_Warrior_Fury Warrior_Fury %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
