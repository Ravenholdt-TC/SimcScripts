setlocal
cd %~dp0\..\..

REM T21
TrinketSimulation.rb Hunter T21_Hunter_Beast_Mastery_DireFrenzy Ranged_Agility 1T q
TrinketSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp Ranged_Agility 1T q
TrinketSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_AotB Ranged_Agility 1T q
TrinketSimulation.rb Hunter T21_Hunter_Beast_Mastery_Stomp-T20-4+T21-2_KC Ranged_Agility 1T q
TrinketSimulation.rb Hunter T21_Hunter_Marksmanship Ranged_Agility 1T q
TrinketSimulation.rb Hunter T21_Hunter_Survival Melee_Agility 1T q

REM T20
TrinketSimulation.rb Hunter T20_Hunter_Beast_Mastery Ranged_Agility 1T q
TrinketSimulation.rb Hunter T20_Hunter_Marksmanship Ranged_Agility 1T q
TrinketSimulation.rb Hunter T20_Hunter_Survival Melee_Agility 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
