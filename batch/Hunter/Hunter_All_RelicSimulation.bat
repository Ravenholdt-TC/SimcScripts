setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_DireFrenzy Hunter_Beast_Mastery %fightstyle% q
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp Hunter_Beast_Mastery %fightstyle% q
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB Hunter_Beast_Mastery %fightstyle% q
RelicSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC Hunter_Beast_Mastery %fightstyle% q
RelicSimulation.rb Hunter T21_Hunter_Marksmanship Hunter_Marksmanship %fightstyle% q
RelicSimulation.rb Hunter T21_Hunter_Marksmanship-Sentinel Hunter_Marksmanship %fightstyle% q
RelicSimulation.rb Hunter T21_Hunter_Survival Hunter_Survival %fightstyle% q

REM T20
RelicSimulation.rb Hunter T20_Hunter_Beast_Mastery Hunter_Beast_Mastery %fightstyle% q
RelicSimulation.rb Hunter T20_Hunter_Marksmanship Hunter_Marksmanship %fightstyle% q
RelicSimulation.rb Hunter T20_Hunter_Survival Hunter_Survival %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
