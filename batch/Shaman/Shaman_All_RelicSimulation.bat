setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Shaman T21_Shaman_Elemental 1T q
RelicSimulation.rb Shaman T21_Shaman_Enhancement 1T q

REM T20
RelicSimulation.rb Shaman T20_Shaman_Elemental 1T q
RelicSimulation.rb Shaman T20_Shaman_Enhancement 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
