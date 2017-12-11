setlocal
cd %~dp0\..\..

REM T21
TrinketSimulation.rb Warlock T21_Warlock_Affliction Ranged_Intelligence 1T q
TrinketSimulation.rb Warlock T21_Warlock_Demonology Ranged_Intelligence 1T q
TrinketSimulation.rb Warlock T21_Warlock_Destruction Ranged_Intelligence 1T q

REM T20
TrinketSimulation.rb Warlock T20_Warlock_Affliction Ranged_Intelligence 1T q
TrinketSimulation.rb Warlock T20_Warlock_Demonology Ranged_Intelligence 1T q
TrinketSimulation.rb Warlock T20_Warlock_Destruction Ranged_Intelligence 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
