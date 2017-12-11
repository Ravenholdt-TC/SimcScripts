setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Paladin T21_Paladin_Retribution Paladin_Retribution T21 1T xx0x00x y q

REM T21H
Combinator.rb Paladin T21H_Paladin_Retribution Paladin_Retribution T21H 1T xx0x00x y q

@if "%1"=="nopause" goto finish
@pause
:finish
