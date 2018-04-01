setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Paladin T21_Paladin_Retribution Paladin_Retribution %fightstyle% q
RelicSimulation.rb Paladin T21_Paladin_Protection Paladin_Protection %fightstyle% q

REM T20
RelicSimulation.rb Paladin T20_Paladin_Retribution Paladin_Retribution %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
