setlocal
cd %~dp0\..\..

REM T21
RelicSimulation.rb Mage T21_Mage_Arcane 1T q
RelicSimulation.rb Mage T21_Mage_Fire 1T q
RelicSimulation.rb Mage T21_Mage_Frost 1T q

REM T20
RelicSimulation.rb Mage T20_Mage_Arcane 1T q
RelicSimulation.rb Mage T20_Mage_Fire 1T q
RelicSimulation.rb Mage T20_Mage_Frost 1T q

@if "%1"=="nopause" goto finish
@pause
:finish
