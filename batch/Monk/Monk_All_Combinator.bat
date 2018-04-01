setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Monk T21_Monk_Windwalker Monk T21 %fightstyle% x0x00xx q

REM T21H
Combinator.rb Monk T21H_Monk_Windwalker Monk T21H %fightstyle% x0x00xx q

@if "%~2"=="nopause" goto finish
@pause
:finish
