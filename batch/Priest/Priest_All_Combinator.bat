setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Priest T21_Priest_Shadow Priest_Shadow T21 %fightstyle% x00xxxx q

REM T21H
Combinator.rb Priest T21H_Priest_Shadow Priest_Shadow T21H %fightstyle% x00xxxx q

@if "%~2"=="nopause" goto finish
@pause
:finish
