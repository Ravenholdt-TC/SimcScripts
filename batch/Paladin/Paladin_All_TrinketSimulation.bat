cd %~dp0\..\..

REM T21
TrinketSimulation.rb Paladin T21_Paladin_Retribution Melee_Strength 1T q

REM T20
TrinketSimulation.rb Paladin T20_Paladin_Retribution Melee_Strength 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
