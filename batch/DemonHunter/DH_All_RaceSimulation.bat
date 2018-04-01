setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb DemonHunter T21_Demon_Hunter_Havoc %fightstyle% q

REM T20
RaceSimulation.rb DemonHunter T20_Demon_Hunter_Havoc %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
