setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Rogue T21_Rogue_Assassination-Mantle+Bracers 1T q
RelicSimulation.rb Rogue T21_Rogue_Assassination-Mantle+Bracers_FoK 1T q
RelicSimulation.rb Rogue T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots 1T q
RelicSimulation.rb Rogue T21_Rogue_Assassination-T21_4+T20_2_Bracers+Boots_FoK 1T q
RelicSimulation.rb Rogue T21_Rogue_Assassination_Exsg 1T q
RelicSimulation.rb Rogue T21_Rogue_Outlaw 1T q
RelicSimulation.rb Rogue T21_Rogue_Outlaw_SnD 1T q
RelicSimulation.rb Rogue T21_Rogue_Subtlety 1T q
RelicSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Mantle+Hands 1T q
RelicSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Soul+Insignia 1T q

REM T20
RelicSimulation.rb Rogue T20_Rogue_Assassination 1T q
RelicSimulation.rb Rogue T20_Rogue_Assassination_Exsg 1T q
RelicSimulation.rb Rogue T20_Rogue_Outlaw 1T q
RelicSimulation.rb Rogue T20_Rogue_Outlaw_SnD 1T q
RelicSimulation.rb Rogue T20_Rogue_Subtlety 1T q
RelicSimulation.rb Rogue T20_Rogue_Subtlety_DfA 1T q

REM T19
RelicSimulation.rb Rogue T19_Rogue_Assassination 1T q
RelicSimulation.rb Rogue T19_Rogue_Outlaw 1T q
RelicSimulation.rb Rogue T19_Rogue_Subtlety 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
