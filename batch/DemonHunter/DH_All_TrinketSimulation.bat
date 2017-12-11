setlocal
cd %~dp0\..\..

REM T21
TrinketSimulation.rb DemonHunter T21_Demon_Hunter_Havoc Melee_Agility 1T q

REM T20
TrinketSimulation.rb DemonHunter T20_Demon_Hunter_Havoc Melee_Agility 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
