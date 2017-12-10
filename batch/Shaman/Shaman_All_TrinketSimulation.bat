cd %~dp0\..\..

REM T21
TrinketSimulation.rb Shaman T21_Shaman_Elemental Ranged_Intelligence 1T q
TrinketSimulation.rb Shaman T21_Shaman_Enhancement Melee_Agility 1T q

REM T20
TrinketSimulation.rb Shaman T20_Shaman_Elemental Ranged_Intelligence 1T q
TrinketSimulation.rb Shaman T20_Shaman_Enhancement Melee_Agility 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
