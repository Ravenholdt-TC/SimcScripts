setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Paladin T21_Paladin_Retribution Paladin T21 1T xx0x00x q

REM T21H
Combinator.rb Paladin T21H_Paladin_Retribution Paladin T21H 1T xx0x00x q

@if "%1"=="nopause" goto finish
@pause
:finish
