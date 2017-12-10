cd %~dp0\..\..

REM T21
RelicSimulation.rb Paladin T21_Paladin_Retribution 1T q

REM T20
RelicSimulation.rb Paladin T20_Paladin_Retribution 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
