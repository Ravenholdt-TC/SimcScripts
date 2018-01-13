setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Warlock T21_Warlock_Affliction Warlock_Affliction T21 1T xx0x0xx q
Combinator.rb Warlock T21_Warlock_Demonology Warlock_Demonology T21 1T xx0x0xx q
Combinator.rb Warlock T21_Warlock_Destruction Warlock_Destruction T21 1T xx0x0xx q

REM T21H
Combinator.rb Warlock T21H_Warlock_Affliction Warlock_Affliction T21H 1T xx0x0xx q
Combinator.rb Warlock T21H_Warlock_Demonology Warlock_Demonology T21H 1T xx0x0xx q
Combinator.rb Warlock T21H_Warlock_Destruction Warlock_Destruction T21H 1T xx0x0xx q

@if "%1"=="nopause" goto finish
@pause
:finish
