setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Shaman T21_Shaman_Elemental Shaman_Elemental %fightstyle% q
RelicSimulation.rb Shaman T21_Shaman_Enhancement Shaman_Enhancement %fightstyle% q

REM T20
RelicSimulation.rb Shaman T20_Shaman_Elemental Shaman_Elemental %fightstyle% q
RelicSimulation.rb Shaman T20_Shaman_Enhancement Shaman_Enhancement %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
