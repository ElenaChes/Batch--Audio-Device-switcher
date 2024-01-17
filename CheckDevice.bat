@if (@CodeSection == @Batch) @then
@echo off
setlocal enabledelayedexpansion
set "VARS_PATH=variables.csv"
::---------------------------------------------------------------------
::1.Reads variables from %VARS_PATH%
::--Required vars: SoundVolumeView, TIMEOUT, COLUMN, DEFAULT, H_DEVICE, S_DEVICE--
::2.Uses %SoundVolumeView% to get the value of %COLUMN% for %S_DEVICE% and %H_DEVICE%
::3.Finds which device's state is set to the %DEFAULT% keyword
::4.Displays info popup for %TIMEOUT% seconds
::---------------------------------------------------------------------
:: Default variables
for /f "tokens=1, 2 delims=," %%a in ('type %VARS_PATH%') do (
	if %%a NEQ "" if %%b NEQ "" ( set "%%a=%%b" )
)
::---------------------------------------------------------------------
::Find default device & display
for /f "delims=" %%a in ('%SoundVolumeView% /GetColumnValue %H_DEVICE% %COLUMN%') do (
	REM Headset
	call if "%%a" == "%DEFAULT%" (
		set "DEVICE=%H_DEVICE%"
		set "INFO=%H_DEVICE%"
		GOTO DISPLAY
	)
)
for /f "delims=" %%a in ('%SoundVolumeView% /GetColumnValue %S_DEVICE% %COLUMN%') do (
	REM Speakers
	call if "%%a" == "%DEFAULT%" (
		set "DEVICE=%S_DEVICE%"
		set "INFO=%S_DEVICE%"
		GOTO DISPLAY
	)
)
:: Handle unknown device
set "ERR=Couldn't detect current device"
echo Current: %ERR%
CScript //nologo //E:JScript "%~F0" %TIMEOUT% "%ERR%" "err"
GOTO END
::---------------------------------------------------------------------
:DISPLAY
:: Display device
echo Current: %INFO%
CScript //nologo //E:JScript "%~F0" %TIMEOUT% %DEVICE%

:END
goto :EOF
@end
//---------------------------------------------------------------------
// Start Cscript and display popup
if (WScript.Arguments.Unnamed.Count < 2) WScript.Quit(0);
var timeout = WScript.Arguments.Unnamed(0);
var text = WScript.Arguments.Unnamed(1);
var WshShell = WScript.CreateObject("WScript.Shell")
if (WScript.Arguments.Unnamed.Count > 2 && WScript.Arguments.Unnamed(2)=="err") 
	WScript.Quit (WshShell.Popup(text ,timeout ,"Error", 0+48))
else
	WScript.Quit (WshShell.Popup(text ,timeout ,"Current default device", 0+64))