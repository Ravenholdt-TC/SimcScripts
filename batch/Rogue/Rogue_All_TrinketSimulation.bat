cd %~dp0\..\..

REM T21
TrinketSimulation.rb Rogue T21_Rogue_Assassination Melee_Agility 1T q
TrinketSimulation.rb Rogue T21_Rogue_Assassination_Exsg Melee_Agility 1T q
TrinketSimulation.rb Rogue T21_Rogue_Outlaw Melee_Agility 1T q
TrinketSimulation.rb Rogue T21_Rogue_Outlaw_SnD Melee_Agility 1T q
TrinketSimulation.rb Rogue T21_Rogue_Subtlety Melee_Agility 1T q
TrinketSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Mantle+Hands Melee_Agility 1T q
TrinketSimulation.rb Rogue T21_Rogue_Subtlety_DfA-Soul+Insignia Melee_Agility 1T q

REM T20
TrinketSimulation.rb Rogue T20_Rogue_Assassination Melee_Agility 1T q
TrinketSimulation.rb Rogue T20_Rogue_Assassination_Exsg Melee_Agility 1T q
TrinketSimulation.rb Rogue T20_Rogue_Outlaw Melee_Agility 1T q
TrinketSimulation.rb Rogue T20_Rogue_Outlaw_SnD Melee_Agility 1T q
TrinketSimulation.rb Rogue T20_Rogue_Subtlety Melee_Agility 1T q
TrinketSimulation.rb Rogue T20_Rogue_Subtlety_DfA Melee_Agility 1T q

REM T19
TrinketSimulation.rb Rogue T19_Rogue_Assassination Melee_Agility 1T q
TrinketSimulation.rb Rogue T19_Rogue_Outlaw Melee_Agility 1T q
TrinketSimulation.rb Rogue T19_Rogue_Subtlety Melee_Agility 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
