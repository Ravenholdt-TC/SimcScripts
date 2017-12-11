setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Warlock T21_Warlock_Affliction 1T q
RelicSimulation.rb Warlock T21_Warlock_Demonology 1T q
RelicSimulation.rb Warlock T21_Warlock_Destruction 1T q

REM T20
RelicSimulation.rb Warlock T20_Warlock_Affliction 1T q
RelicSimulation.rb Warlock T20_Warlock_Demonology 1T q
RelicSimulation.rb Warlock T20_Warlock_Destruction 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
