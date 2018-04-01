setlocal enabledelayedexpansion
cd %~dp0\..\..

set fightstyle=%~1
@if "%~1"=="" set fightstyle="1T"

REM T21
Combinator.rb Mage T21_Mage_Arcane Mage_Arcane T21 %fightstyle% x0xx0xx q
Combinator.rb Mage T21_Mage_Fire Mage_Fire T21 %fightstyle% x0xx0xx q
Combinator.rb Mage T21_Mage_Frost Mage_Frost T21 %fightstyle% x0xx0xx q

REM T21H
Combinator.rb Mage T21H_Mage_Arcane Mage_Arcane T21H %fightstyle% x0xx0xx q
Combinator.rb Mage T21H_Mage_Fire Mage_Fire T21H %fightstyle% x0xx0xx q
Combinator.rb Mage T21H_Mage_Frost Mage_Frost T21H %fightstyle% x0xx0xx q

@if "%~2"=="nopause" goto finish
@pause
:finish
