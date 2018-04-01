setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb Priest T21_Priest_Shadow %fightstyle% q
RaceSimulation.rb Priest T21_Priest_Shadow_S2M %fightstyle% q

REM T20
RaceSimulation.rb Priest T20_Priest_Shadow %fightstyle% q
RaceSimulation.rb Priest T20_Priest_Shadow_S2M %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
