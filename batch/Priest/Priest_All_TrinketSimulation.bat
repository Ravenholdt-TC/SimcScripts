setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Priest T21_Priest_Shadow Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Priest T21_Priest_Shadow_S2M Ranged_Intelligence %fightstyle% q

REM T20
TrinketSimulation.rb Priest T20_Priest_Shadow Ranged_Intelligence %fightstyle% q
TrinketSimulation.rb Priest T20_Priest_Shadow_S2M Ranged_Intelligence %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
