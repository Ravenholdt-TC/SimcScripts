setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb DemonHunter T21_Demon_Hunter_Havoc Demon_Hunter T21 %fightstyle% xxx0xxx q

REM T21H
Combinator.rb DemonHunter T21H_Demon_Hunter_Havoc Demon_Hunter T21H %fightstyle% xxx0xxx q

@if "%~2"=="nopause" goto finish
@pause
:finish
