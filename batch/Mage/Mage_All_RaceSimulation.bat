setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb Mage T21_Mage_Arcane %fightstyle% q
RaceSimulation.rb Mage T21_Mage_Fire %fightstyle% q
RaceSimulation.rb Mage T21_Mage_Frost %fightstyle% q

REM T20
RaceSimulation.rb Mage T20_Mage_Arcane %fightstyle% q
RaceSimulation.rb Mage T20_Mage_Fire %fightstyle% q
RaceSimulation.rb Mage T20_Mage_Frost %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
