cd %~dp0\..\..

REM T21
TrinketSimulation.rb Warrior T21_Warrior_Arms Melee_Strength 1T q
TrinketSimulation.rb Warrior T21_Warrior_Fury Melee_Strength 1T q

REM T20
TrinketSimulation.rb Warrior T20_Warrior_Arms Melee_Strength 1T q
TrinketSimulation.rb Warrior T20_Warrior_Fury Melee_Strength 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
