setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Druid T21_Druid_Balance Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Druid T21_Druid_Balance-Stellar_Drift Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Druid T21_Druid_Feral Melee_Agility %fightstyle% q
TrinketSimulation.rb Druid T21_Druid_Guardian Melee_Agility %fightstyle% q

REM T20
TrinketSimulation.rb Druid T20_Druid_Balance Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Druid T20_Druid_Feral Melee_Agility %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
