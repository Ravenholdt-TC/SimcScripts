setlocal
cd %~dp0\..\..

REM T21
TrinketSimulation.rb Priest T21_Priest_Shadow Ranged_Intelligence 1T q
TrinketSimulation.rb Priest T21_Priest_Shadow_S2M Ranged_Intelligence 1T q

REM T20
TrinketSimulation.rb Priest T20_Priest_Shadow Ranged_Intelligence 1T q
TrinketSimulation.rb Priest T20_Priest_Shadow_S2M Ranged_Intelligence 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
