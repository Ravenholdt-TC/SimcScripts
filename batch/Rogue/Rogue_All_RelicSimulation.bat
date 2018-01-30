setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Rogue T21_Rogue_Assassination-Mantle+Bracers Rogue_Assassination 1T q
RelicSimulation.rb Rogue T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots Rogue_Assassination 1T q
RelicSimulation.rb Rogue T21_Rogue_Assassination_Exsg Rogue_Assassination 1T q
RelicSimulation.rb Rogue T21_Rogue_Outlaw Rogue_Outlaw 1T q
RelicSimulation.rb Rogue T21_Rogue_Outlaw_SnD Rogue_Outlaw 1T q
RelicSimulation.rb Rogue T21_Rogue_Subtlety Rogue_Subtlety 1T q
RelicSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Mantle+Hands Rogue_Subtlety 1T q
RelicSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Soul+Insignia Rogue_Subtlety 1T q

REM T20
RelicSimulation.rb Rogue T20_Rogue_Assassination Rogue_Assassination 1T q
RelicSimulation.rb Rogue T20_Rogue_Assassination_Exsg Rogue_Assassination 1T q
RelicSimulation.rb Rogue T20_Rogue_Outlaw Rogue_Outlaw 1T q
RelicSimulation.rb Rogue T20_Rogue_Outlaw_SnD Rogue_Outlaw 1T q
RelicSimulation.rb Rogue T20_Rogue_Subtlety Rogue_Subtlety 1T q
RelicSimulation.rb Rogue T20_Rogue_Subtlety_DfA Rogue_Subtlety 1T q

REM T19
RelicSimulation.rb Rogue T19_Rogue_Assassination Rogue_Assassination 1T q
RelicSimulation.rb Rogue T19_Rogue_Outlaw Rogue_Outlaw 1T q
RelicSimulation.rb Rogue T19_Rogue_Subtlety Rogue_Subtlety 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
