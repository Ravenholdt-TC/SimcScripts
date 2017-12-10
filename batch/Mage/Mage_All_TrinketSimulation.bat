cd %~dp0\..\..

REM T21
TrinketSimulation.rb Mage T21_Mage_Arcane Ranged_Intelligence 1T q
TrinketSimulation.rb Mage T21_Mage_Fire Ranged_Intelligence 1T q
TrinketSimulation.rb Mage T21_Mage_Frost Ranged_Intelligence 1T q

REM T20
TrinketSimulation.rb Mage T20_Mage_Arcane Ranged_Intelligence 1T q
TrinketSimulation.rb Mage T20_Mage_Fire Ranged_Intelligence 1T q
TrinketSimulation.rb Mage T20_Mage_Frost Ranged_Intelligence 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
