setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Shaman T21_Shaman_Elemental Shaman_Elemental T21 1T x00xxxx y q
Combinator.rb Shaman T21_Shaman_Enhancement Shaman_Enhancement T21 1T x00xxxx y q

REM T21H
Combinator.rb Shaman T21H_Shaman_Elemental Shaman_Elemental T21H 1T x00xxxx y q
Combinator.rb Shaman T21H_Shaman_Enhancement Shaman_Enhancement T21H 1T x00xxxx y q

@if "%1"=="nopause" goto finish
@pause
:finish
