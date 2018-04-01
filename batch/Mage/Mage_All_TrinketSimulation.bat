setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Mage T21_Mage_Arcane Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Mage T21_Mage_Fire Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Mage T21_Mage_Frost Ranged_Intelligence %fightstyle% q

REM T20
TrinketSimulation.rb Mage T20_Mage_Arcane Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Mage T20_Mage_Fire Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Mage T20_Mage_Frost Ranged_Intelligence %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
