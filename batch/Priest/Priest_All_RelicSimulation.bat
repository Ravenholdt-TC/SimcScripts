setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Priest T21_Priest_Shadow Priest_Shadow %fightstyle% q
RelicSimulation.rb Priest T21_Priest_Shadow_S2M Priest_Shadow %fightstyle% q

REM T20
RelicSimulation.rb Priest T20_Priest_Shadow Priest_Shadow %fightstyle% q
RelicSimulation.rb Priest T20_Priest_Shadow_S2M Priest_Shadow %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
