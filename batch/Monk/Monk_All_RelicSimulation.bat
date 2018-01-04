setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Monk T21_Monk_Windwalker Monk_Windwalker 1T q
RelicSimulation.rb Monk T21_Monk_Brewmaster Monk_Brewmaster 1T q

REM T20
RelicSimulation.rb Monk T20_Monk_Windwalker Monk_Windwalker 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
