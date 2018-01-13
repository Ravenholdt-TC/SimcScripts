setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Priest T21_Priest_Shadow Priest_Shadow T21 1T x00xxxx q

REM T21H
Combinator.rb Priest T21H_Priest_Shadow Priest_Shadow T21H 1T x00xxxx q

@if "%1"=="nopause" goto finish
@pause
:finish
