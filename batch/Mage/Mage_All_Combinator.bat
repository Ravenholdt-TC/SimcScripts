setlocal
cd %~dp0\..\..

REM T21
Combinator.rb Mage T21_Mage_Arcane Mage_Arcane T21 1T x0xx0xx q
Combinator.rb Mage T21_Mage_Fire Mage_Fire T21 1T x0xx0xx q
Combinator.rb Mage T21_Mage_Frost Mage_Frost T21 1T x0xx0xx q

REM T21H
Combinator.rb Mage T21H_Mage_Arcane Mage_Arcane T21H 1T x0xx0xx q
Combinator.rb Mage T21H_Mage_Fire Mage_Fire T21H 1T x0xx0xx q
Combinator.rb Mage T21H_Mage_Frost Mage_Frost T21H 1T x0xx0xx q

@if "%1"=="nopause" goto finish
@pause
:finish
