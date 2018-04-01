setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb Hunter T21_Hunter_Beast_Mastery_DireFrenzy %fightstyle% q
RaceSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp %fightstyle% q
RaceSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB %fightstyle% q
RaceSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC %fightstyle% q
RaceSimulation.rb Hunter T21_Hunter_Marksmanship %fightstyle% q
RaceSimulation.rb Hunter T21_Hunter_Marksmanship-Sentinel %fightstyle% q
RaceSimulation.rb Hunter T21_Hunter_Survival %fightstyle% q

REM T20
RaceSimulation.rb Hunter T20_Hunter_Beast_Mastery %fightstyle% q
RaceSimulation.rb Hunter T20_Hunter_Marksmanship %fightstyle% q
RaceSimulation.rb Hunter T20_Hunter_Survival %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
