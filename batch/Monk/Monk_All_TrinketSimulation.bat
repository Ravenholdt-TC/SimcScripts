setlocal
cd %~dp0\..\..

REM T21
TrinketSimulation.rb Monk T21_Monk_Windwalker Melee_Agility 1T q
TrinketSimulation.rb Monk T21_Monk_Brewmaster Melee_Agility 1T q

REM T20
TrinketSimulation.rb Monk T20_Monk_Windwalker Melee_Agility 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
