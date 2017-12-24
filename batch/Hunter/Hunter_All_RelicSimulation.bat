setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_DireFrenzy Hunter_Beast_Mastery 1T q
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp Hunter_Beast_Mastery 1T q
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB Hunter_Beast_Mastery 1T q
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC Hunter_Beast_Mastery 1T q
RelicSimulation.rb Hunter T21_Hunter_Marksmanship Hunter_Marksmanship 1T q
RelicSimulation.rb Hunter T21_Hunter_Survival Hunter_Survival 1T q

REM T20
RelicSimulation.rb Hunter T20_Hunter_Beast_Mastery Hunter_Beast_Mastery 1T q
RelicSimulation.rb Hunter T20_Hunter_Marksmanship Hunter_Marksmanship 1T q
RelicSimulation.rb Hunter T20_Hunter_Survival Hunter_Survival 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
