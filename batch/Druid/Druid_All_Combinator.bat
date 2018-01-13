setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Druid T21_Druid_Balance Druid_Balance T21 1T x000xxx q
Combinator.rb Druid T21_Druid_Feral Druid_Feral T21 1T x000xxx q

REM T21H
Combinator.rb Druid T21H_Druid_Balance Druid_Balance T21H 1T x000xxx q
Combinator.rb Druid T21H_Druid_Feral Druid_Feral T21H 1T x000xxx q

@if "%1"=="nopause" goto finish
@pause
:finish
