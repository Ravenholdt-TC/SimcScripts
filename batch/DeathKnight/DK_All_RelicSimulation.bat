setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb DeathKnight T21_Death_Knight_Frost 1T q
RelicSimulation.rb DeathKnight T21_Death_Knight_Unholy 1T q

REM T20
RelicSimulation.rb DeathKnight T20_Death_Knight_Frost 1T q
RelicSimulation.rb DeathKnight T20_Death_Knight_Unholy 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
