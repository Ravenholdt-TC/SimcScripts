setlocal
cd %~dp0\..\..

REM T21
Combinator.rb DeathKnight T21_Death_Knight_Frost Death_Knight_Frost T21 1T xxx00xx y q
Combinator.rb DeathKnight T21_Death_Knight_Unholy Death_Knight_Unholy T21 1T xxx00xx y q

REM T21H
Combinator.rb DeathKnight T21H_Death_Knight_Frost Death_Knight_Frost T21H 1T xxx00xx y q
Combinator.rb DeathKnight T21H_Death_Knight_Unholy Death_Knight_Unholy T21H 1T xxx00xx y q

@if "%1"=="nopause" goto finish
@pause
:finish
