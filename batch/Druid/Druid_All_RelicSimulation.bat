setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Druid T21_Druid_Balance Druid_Balance 1T q
RelicSimulation.rb Druid T21_Druid_Balance-Stellar_Drift Druid_Balance 1T q
RelicSimulation.rb Druid T21_Druid_Feral Druid_Feral 1T q

REM T20
RelicSimulation.rb Druid T20_Druid_Balance Druid_Balance 1T q
RelicSimulation.rb Druid T20_Druid_Feral Druid_Feral 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
