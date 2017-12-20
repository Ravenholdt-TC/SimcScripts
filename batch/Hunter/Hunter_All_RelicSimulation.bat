setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_DireFrenzy 1T q
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp 1T q
RelicSimulation.rb Hunter T21_Hunter_Marksmanship 1T q
RelicSimulation.rb Hunter T21_Hunter_Survival 1T q

REM T20
RelicSimulation.rb Hunter T20_Hunter_Beast_Mastery 1T q
RelicSimulation.rb Hunter T20_Hunter_Marksmanship 1T q
RelicSimulation.rb Hunter T20_Hunter_Survival 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
