setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RaceSimulation.rb Rogue T21_Rogue_Assassination-Mantle+Bracers %fightstyle% q
RaceSimulation.rb Rogue T21_Rogue_Assassination-Boots+Bracers %fightstyle% q
RaceSimulation.rb Rogue T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots %fightstyle% q
RaceSimulation.rb Rogue T21_Rogue_Assassination_Exsg %fightstyle% q
RaceSimulation.rb Rogue T21_Rogue_Outlaw %fightstyle% q
RaceSimulation.rb Rogue T21_Rogue_Outlaw_SnD %fightstyle% q
RaceSimulation.rb Rogue T21_Rogue_Subtlety %fightstyle% q
RaceSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Mantle+Hands %fightstyle% q
RaceSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Soul+Insignia %fightstyle% q

REM T20
RaceSimulation.rb Rogue T20_Rogue_Assassination %fightstyle% q
RaceSimulation.rb Rogue T20_Rogue_Assassination_Exsg %fightstyle% q
RaceSimulation.rb Rogue T20_Rogue_Outlaw %fightstyle% q
RaceSimulation.rb Rogue T20_Rogue_Outlaw_SnD %fightstyle% q
RaceSimulation.rb Rogue T20_Rogue_Subtlety %fightstyle% q
RaceSimulation.rb Rogue T20_Rogue_Subtlety_DfA %fightstyle% q

REM T19
RaceSimulation.rb Rogue T19_Rogue_Assassination %fightstyle% q
RaceSimulation.rb Rogue T19_Rogue_Outlaw %fightstyle% q
RaceSimulation.rb Rogue T19_Rogue_Subtlety %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
