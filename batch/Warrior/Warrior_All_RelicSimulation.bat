setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Warrior T21_Warrior_Arms 1T q
RelicSimulation.rb Warrior T21_Warrior_Fury 1T q

REM T20
RelicSimulation.rb Warrior T20_Warrior_Arms 1T q
RelicSimulation.rb Warrior T20_Warrior_Fury 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
