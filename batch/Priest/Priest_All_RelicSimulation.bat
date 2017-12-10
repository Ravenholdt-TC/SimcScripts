cd %~dp0\..\..

REM T21
RelicSimulation.rb Priest T21_Priest_Shadow 1T q
RelicSimulation.rb Priest T21_Priest_Shadow_S2M 1T q

REM T20
RelicSimulation.rb Priest T20_Priest_Shadow 1T q
RelicSimulation.rb Priest T20_Priest_Shadow_S2M 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
