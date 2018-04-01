setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Warrior T21_Warrior_Arms Warrior_Arms T21 %fightstyle% x3x2xxx q
Combinator.rb Warrior T21_Warrior_Fury Warrior_Fury T21 %fightstyle% x3x2xxx q

REM T21H
Combinator.rb Warrior T21H_Warrior_Arms Warrior_Arms T21H %fightstyle% x3x2xxx q
Combinator.rb Warrior T21H_Warrior_Fury Warrior_Fury T21H %fightstyle% x3x2xxx q

@if "%~2"=="nopause" goto finish
@pause
:finish
