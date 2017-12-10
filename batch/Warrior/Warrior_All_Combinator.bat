cd %~dp0\..\..

REM T21
Combinator.rb Warrior T21_Warrior_Arms Warrior_Arms T21 1T x3x2xxx y q
Combinator.rb Warrior T21_Warrior_Fury Warrior_Fury T21 1T x3x2xxx y q

REM T21H
Combinator.rb Warrior T21H_Warrior_Arms Warrior_Arms T21H 1T x3x2xxx y q
Combinator.rb Warrior T21H_Warrior_Fury Warrior_Fury T21H 1T x3x2xxx y q

@if "%1"=="nopause" goto finish
@pause
:finish
