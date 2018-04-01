setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Hunter T21_Hunter_Beast_Mastery-Mastery-Build Hunter_Beast_Mastery_Mastery T21 %fightstyle% xx0x0xx q
Combinator.rb Hunter T21_Hunter_Beast_Mastery-Crit-Build Hunter_Beast_Mastery_Stomp T21 %fightstyle% xx0x0xx q
Combinator.rb Hunter T21_Hunter_Marksmanship Hunter_Marksmanship T21 %fightstyle% xx0x0xx q
Combinator.rb Hunter T21_Hunter_Survival Hunter_Survival T21 %fightstyle% xx0x0xx q

REM T21H
Combinator.rb Hunter T21H_Hunter_Beast_Mastery-Mastery-Build Hunter_Beast_Mastery_Mastery T21H %fightstyle% xx0x0xx q
Combinator.rb Hunter T21H_Hunter_Beast_Mastery-Crit-Build Hunter_Beast_Mastery_Stomp T21H %fightstyle% xx0x0xx q
Combinator.rb Hunter T21H_Hunter_Marksmanship Hunter_Marksmanship T21H %fightstyle% xx0x0xx q
Combinator.rb Hunter T21H_Hunter_Survival Hunter_Survival T21H %fightstyle% xx0x0xx q

@if "%~2"=="nopause" goto finish
@pause
:finish
