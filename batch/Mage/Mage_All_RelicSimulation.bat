setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Mage T21_Mage_Arcane Mage_Arcane %fightstyle% q
RelicSimulation.rb Mage T21_Mage_Fire Mage_Fire %fightstyle% q
RelicSimulation.rb Mage T21_Mage_Frost Mage_Frost %fightstyle% q

REM T20
RelicSimulation.rb Mage T20_Mage_Arcane Mage_Arcane %fightstyle% q
RelicSimulation.rb Mage T20_Mage_Fire Mage_Fire %fightstyle% q
RelicSimulation.rb Mage T20_Mage_Frost Mage_Frost %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
