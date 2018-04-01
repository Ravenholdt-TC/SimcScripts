setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Druid T21_Druid_Balance Druid_Balance %fightstyle% q
RelicSimulation.rb Druid T21_Druid_Balance-Stellar_Drift Druid_Balance %fightstyle% q
RelicSimulation.rb Druid T21_Druid_Feral-BS_+_BT Druid_Feral %fightstyle% q
RelicSimulation.rb Druid T21_Druid_Feral-LI_+_Incarnation Druid_Feral %fightstyle% q
RelicSimulation.rb Druid T21_Druid_Feral-LI_+_Soul_of_the_Forest Druid_Feral %fightstyle% q
RelicSimulation.rb Druid T21_Druid_Guardian Druid_Guardian %fightstyle% q

REM T20
RelicSimulation.rb Druid T20_Druid_Balance Druid_Balance %fightstyle% q
RelicSimulation.rb Druid T20_Druid_Feral Druid_Feral %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
