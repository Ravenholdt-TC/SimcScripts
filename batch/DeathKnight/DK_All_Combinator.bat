setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb DeathKnight T21_Death_Knight_Frost Death_Knight_Frost T21 %fightstyle% xxx00xx q
Combinator.rb DeathKnight T21_Death_Knight_Unholy Death_Knight_Unholy T21 %fightstyle% xxx00xx q

REM T21H
Combinator.rb DeathKnight T21H_Death_Knight_Frost Death_Knight_Frost T21H %fightstyle% xxx00xx q
Combinator.rb DeathKnight T21H_Death_Knight_Unholy Death_Knight_Unholy T21H %fightstyle% xxx00xx q

@if "%~2"=="nopause" goto finish
@pause
:finish
