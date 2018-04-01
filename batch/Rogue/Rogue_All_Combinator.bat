setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Rogue T21_Rogue_Assassination-Poison Rogue T21 %fightstyle% xxx00[12]x q
Combinator.rb Rogue T21_Rogue_Assassination-Bleed Rogue_Assassination_Exsg T21 %fightstyle% xxx003x q
Combinator.rb Rogue T21_Rogue_Outlaw-Roll_the_Bones Rogue T21 %fightstyle% x3x00x[23] q
Combinator.rb Rogue T21_Rogue_Outlaw-Slice_and_Dice Rogue_Outlaw_SnD T21 %fightstyle% x3x00x1 q
Combinator.rb Rogue T21_Rogue_Subtlety Rogue T21 %fightstyle% xxx00xx q

REM T21H
Combinator.rb Rogue T21H_Rogue_Assassination-Poison Rogue T21H %fightstyle% xxx00[12]x q
Combinator.rb Rogue T21H_Rogue_Assassination-Bleed Rogue_Assassination_Exsg T21H %fightstyle% xxx003x q
Combinator.rb Rogue T21H_Rogue_Outlaw-Roll_the_Bones Rogue T21H %fightstyle% x3x00x[23] q
Combinator.rb Rogue T21H_Rogue_Outlaw-Slice_and_Dice Rogue_Outlaw_SnD T21H %fightstyle% x3x00x1 q
Combinator.rb Rogue T21H_Rogue_Subtlety Rogue T21H %fightstyle% xxx00xx q

REM T20
Combinator.rb Rogue T20_Rogue_Assassination Rogue T20 %fightstyle% xxx00xx q
Combinator.rb Rogue T20_Rogue_Outlaw Rogue T20 %fightstyle% x3x00xx q
Combinator.rb Rogue T20_Rogue_Subtlety Rogue T20 %fightstyle% xxx00xx q

REM T19
Combinator.rb Rogue T19_Rogue_Assassination Rogue T19 %fightstyle% xxx00xx q
Combinator.rb Rogue T19_Rogue_Outlaw Rogue T19 %fightstyle% x3x00xx q
Combinator.rb Rogue T19_Rogue_Subtlety Rogue T19 %fightstyle% xxx00xx q

REM PR
Combinator.rb Rogue PR_Rogue_Assassination Rogue PR %fightstyle% xxx00xx q
Combinator.rb Rogue PR_Rogue_Outlaw Rogue PR %fightstyle% x3x00xx q
Combinator.rb Rogue PR_Rogue_Subtlety Rogue PR %fightstyle% xxx00xx q

@if "%~2"=="nopause" goto finish
@pause
:finish
