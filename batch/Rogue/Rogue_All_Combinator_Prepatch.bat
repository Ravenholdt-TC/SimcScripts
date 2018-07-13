setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21 Prepatch 8.0
Combinator.rb Rogue T21P_Rogue_Assassination Rogue_Prepatch T21 %fightstyle% xxx00xx q
Combinator.rb Rogue T21P_Rogue_Outlaw Rogue_Prepatch T21 %fightstyle% x3x00xx q
Combinator.rb Rogue T21P_Rogue_Subtlety Rogue_Prepatch T21 %fightstyle% xxx00xx q

@if "%~2"=="nopause" goto finish
@pause
:finish
