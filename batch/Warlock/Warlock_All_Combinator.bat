setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Warlock T21_Warlock_Affliction Warlock_Affliction T21 %fightstyle% xx0x0xx q
Combinator.rb Warlock T21_Warlock_Demonology Warlock_Demonology T21 %fightstyle% xx0x0xx q
Combinator.rb Warlock T21_Warlock_Destruction Warlock_Destruction T21 %fightstyle% xx0x0xx q

REM T21H
Combinator.rb Warlock T21H_Warlock_Affliction Warlock_Affliction T21H %fightstyle% xx0x0xx q
Combinator.rb Warlock T21H_Warlock_Demonology Warlock_Demonology T21H %fightstyle% xx0x0xx q
Combinator.rb Warlock T21H_Warlock_Destruction Warlock_Destruction T21H %fightstyle% xx0x0xx q

@if "%~2"=="nopause" goto finish
@pause
:finish
