setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Shaman T21_Shaman_Elemental Shaman_Elemental T21 %fightstyle% x00xxxx q
Combinator.rb Shaman T21_Shaman_Enhancement Shaman_Enhancement T21 %fightstyle% x00xxxx q

REM T21H
Combinator.rb Shaman T21H_Shaman_Elemental Shaman_Elemental T21H %fightstyle% x00xxxx q
Combinator.rb Shaman T21H_Shaman_Enhancement Shaman_Enhancement T21H %fightstyle% x00xxxx q

@if "%~2"=="nopause" goto finish
@pause
:finish
