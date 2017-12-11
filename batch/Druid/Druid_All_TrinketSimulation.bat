setlocal
cd %~dp0\..\..

REM T21
TrinketSimulation.rb Druid T21_Druid_Balance Ranged_Intelligence 1T q
TrinketSimulation.rb Druid T21_Druid_Feral Melee_Agility 1T q

REM T20
TrinketSimulation.rb Druid T20_Druid_Balance Ranged_Intelligence 1T q
TrinketSimulation.rb Druid T20_Druid_Feral Melee_Agility 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
