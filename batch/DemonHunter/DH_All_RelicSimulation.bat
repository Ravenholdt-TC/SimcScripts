cd %~dp0\..\..

REM T21
RelicSimulation.rb DemonHunter T21_Demon_Hunter_Havoc 1T q

REM T20
RelicSimulation.rb DemonHunter T20_Demon_Hunter_Havoc 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
