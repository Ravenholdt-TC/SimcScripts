setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb Paladin T21_Paladin_Retribution %fightstyle% q
RaceSimulation.rb Paladin T21_Paladin_Protection %fightstyle% q

REM T20
RaceSimulation.rb Paladin T20_Paladin_Retribution %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
