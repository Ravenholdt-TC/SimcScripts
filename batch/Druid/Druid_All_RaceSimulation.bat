setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb Druid T21_Druid_Balance %fightstyle% q
RaceSimulation.rb Druid T21_Druid_Balance-Stellar_Drift %fightstyle% q
RaceSimulation.rb Druid T21_Druid_Feral-BS_+_BT %fightstyle% q
RaceSimulation.rb Druid T21_Druid_Feral-LI_+_Incarnation %fightstyle% q
RaceSimulation.rb Druid T21_Druid_Feral-LI_+_Soul_of_the_Forest %fightstyle% q
RaceSimulation.rb Druid T21_Druid_Guardian %fightstyle% q

REM T20
RaceSimulation.rb Druid T20_Druid_Balance %fightstyle% q
RaceSimulation.rb Druid T20_Druid_Feral %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
