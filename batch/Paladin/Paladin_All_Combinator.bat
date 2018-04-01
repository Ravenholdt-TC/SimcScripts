setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Paladin T21_Paladin_Retribution Paladin T21 %fightstyle% xx0x00x q

REM T21H
Combinator.rb Paladin T21H_Paladin_Retribution Paladin T21H %fightstyle% xx0x00x q

@if "%~2"=="nopause" goto finish
@pause
:finish
