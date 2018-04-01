setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
RelicSimulation.rb Rogue T21_Rogue_Assassination-Mantle+Bracers Rogue_Assassination %fightstyle% q
RelicSimulation.rb Rogue T21_Rogue_Assassination-Boots+Bracers Rogue_Assassination %fightstyle% q
RelicSimulation.rb Rogue T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots Rogue_Assassination %fightstyle% q
RelicSimulation.rb Rogue T21_Rogue_Assassination_Exsg Rogue_Assassination %fightstyle% q
RelicSimulation.rb Rogue T21_Rogue_Outlaw Rogue_Outlaw %fightstyle% q
RelicSimulation.rb Rogue T21_Rogue_Outlaw_SnD Rogue_Outlaw %fightstyle% q
RelicSimulation.rb Rogue T21_Rogue_Subtlety Rogue_Subtlety %fightstyle% q
RelicSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Mantle+Hands Rogue_Subtlety %fightstyle% q
RelicSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Soul+Insignia Rogue_Subtlety %fightstyle% q

REM T20
RelicSimulation.rb Rogue T20_Rogue_Assassination Rogue_Assassination %fightstyle% q
RelicSimulation.rb Rogue T20_Rogue_Assassination_Exsg Rogue_Assassination %fightstyle% q
RelicSimulation.rb Rogue T20_Rogue_Outlaw Rogue_Outlaw %fightstyle% q
RelicSimulation.rb Rogue T20_Rogue_Outlaw_SnD Rogue_Outlaw %fightstyle% q
RelicSimulation.rb Rogue T20_Rogue_Subtlety Rogue_Subtlety %fightstyle% q
RelicSimulation.rb Rogue T20_Rogue_Subtlety_DfA Rogue_Subtlety %fightstyle% q

REM T19
RelicSimulation.rb Rogue T19_Rogue_Assassination Rogue_Assassination %fightstyle% q
RelicSimulation.rb Rogue T19_Rogue_Outlaw Rogue_Outlaw %fightstyle% q
RelicSimulation.rb Rogue T19_Rogue_Subtlety Rogue_Subtlety %fightstyle% q

@if "%~2"=="nopause" goto finish
@pause
:finish
