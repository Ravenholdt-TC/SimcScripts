setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Rogue T21_Rogue_Assassination-Poison Rogue T21 1T xxx00[12]x y q
Combinator.rb Rogue T21_Rogue_Assassination-Poison_FoK Rogue T21 1T xxx00[12]1 y q
Combinator.rb Rogue T21_Rogue_Assassination-Bleed Rogue_Assassination_Exsg T21 1T xxx003x y q
Combinator.rb Rogue T21_Rogue_Outlaw-Roll_the_Bones Rogue T21 1T x3x00x[23] y q
Combinator.rb Rogue T21_Rogue_Outlaw-Slice_and_Dice Rogue_Outlaw_SnD T21 1T x3x00x1 y q
Combinator.rb Rogue T21_Rogue_Subtlety Rogue T21 1T xxx00xx y q

REM T21H
Combinator.rb Rogue T21H_Rogue_Assassination-Poison Rogue T21H 1T xxx00[12]x y q
Combinator.rb Rogue T21H_Rogue_Assassination-Poison_FoK Rogue T21 1T xxx00[12]1 y q
Combinator.rb Rogue T21H_Rogue_Assassination-Bleed Rogue_Assassination_Exsg T21H 1T xxx003x y q
Combinator.rb Rogue T21H_Rogue_Outlaw-Roll_the_Bones Rogue T21H 1T x3x00x[23] y q
Combinator.rb Rogue T21H_Rogue_Outlaw-Slice_and_Dice Rogue_Outlaw_SnD T21H 1T x3x00x1 y q
Combinator.rb Rogue T21H_Rogue_Subtlety Rogue T21H 1T xxx00xx y q

REM T20
Combinator.rb Rogue T20_Rogue_Assassination Rogue T20 1T xxx00xx y q
Combinator.rb Rogue T20_Rogue_Outlaw Rogue T20 1T x3x00xx y q
Combinator.rb Rogue T20_Rogue_Subtlety Rogue T20 1T xxx00xx y q

REM T19
Combinator.rb Rogue T19_Rogue_Assassination Rogue T19 1T xxx00xx y q
Combinator.rb Rogue T19_Rogue_Outlaw Rogue T19 1T x3x00xx y q
Combinator.rb Rogue T19_Rogue_Subtlety Rogue T19 1T xxx00xx y q

REM PR
Combinator.rb Rogue PR_Rogue_Assassination Rogue PR 1T xxx00xx y q
Combinator.rb Rogue PR_Rogue_Outlaw Rogue PR 1T x3x00xx y q
Combinator.rb Rogue PR_Rogue_Subtlety Rogue PR 1T xxx00xx y q

@if "%1"=="nopause" goto finish
@pause
:finish
