setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Druid T21_Druid_Balance Druid_Balance T21 %fightstyle% x000xxx q
Combinator.rb Druid T21_Druid_Feral Druid_Feral T21 %fightstyle% x000xxx q

REM T21H
Combinator.rb Druid T21H_Druid_Balance Druid_Balance T21H %fightstyle% x000xxx q
Combinator.rb Druid T21H_Druid_Feral Druid_Feral T21H %fightstyle% x000xxx q

@if "%~2"=="nopause" goto finish
@pause
:finish
