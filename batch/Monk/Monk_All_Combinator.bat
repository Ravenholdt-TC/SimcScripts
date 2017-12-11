setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Monk T21_Monk_Windwalker Monk T21 1T x0x00xx y q

REM T21H
Combinator.rb Monk T21H_Monk_Windwalker Monk T21H 1T x0x00xx y q

@if "%1"=="nopause" goto finish
@pause
:finish
