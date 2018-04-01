setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
TrinketSimulation.rb Hunter T21_Hunter_Beast_Mastery_DireFrenzy Ranged_Agility %fightstyle% q
TrinketSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp Ranged_Agility %fightstyle% q
TrinketSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB Ranged_Agility %fightstyle% q
TrinketSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC Ranged_Agility %fightstyle% q
TrinketSimulation.rb Hunter T21_Hunter_Marksmanship Ranged_Agility %fightstyle% q
TrinketSimulation.rb Hunter T21_Hunter_Survival Melee_Agility %fightstyle% q

REM T20
TrinketSimulation.rb Hunter T20_Hunter_Beast_Mastery Ranged_Agility %fightstyle% q
TrinketSimulation.rb Hunter T20_Hunter_Marksmanship Ranged_Agility %fightstyle% q
TrinketSimulation.rb Hunter T20_Hunter_Survival Melee_Agility %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
