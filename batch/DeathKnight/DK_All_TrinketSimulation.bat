setlocal
cd %~dp0\..\..

REM T21
TrinketSimulation.rb DeathKnight T21_Death_Knight_Frost Melee_Strength 1T q
TrinketSimulation.rb DeathKnight T21_Death_Knight_Frost-Cold_Heart+Runic_Attenuation Melee_Strength 1T q
TrinketSimulation.rb DeathKnight T21_Death_Knight_Unholy Melee_Strength 1T q
TrinketSimulation.rb DeathKnight T21_Death_Knight_Blood Melee_Strength 1T q

REM T20
TrinketSimulation.rb DeathKnight T20_Death_Knight_Frost Melee_Strength 1T q
TrinketSimulation.rb DeathKnight T20_Death_Knight_Unholy Melee_Strength 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
