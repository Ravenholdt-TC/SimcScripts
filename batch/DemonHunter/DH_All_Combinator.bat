cd %~dp0\..\..

REM T21
Combinator.rb DemonHunter T21_Demon_Hunter_Havoc Demon_Hunter T21 1T xxx0xxx y q

REM T21H
Combinator.rb DemonHunter T21H_Demon_Hunter_Havoc Demon_Hunter T21H 1T xxx0xxx y q

@if "%1"=="nopause" goto finish
@pause
:finish
