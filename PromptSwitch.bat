@if (@CodeSection == @Batch) @then
@echo off
chcp 65001 > NUL
setlocal enabledelayedexpansion
set "VARS_PATH=variables.csv"
::---------------------------------------------------------------------
::1.Reads variables from %VARS_PATH%
::--Required vars: SoundVolumeView, TIMEOUT, COLUMN, DEFAULT, H_DEVICE, S_DEVICE, H_VOLUME, S_VOLUME--
::2.Uses %SoundVolumeView% to get the value of %COLUMN% for %S_DEVICE% and %H_DEVICE%
::3.Finds which device's state is set to the %DEFAULT% keyword
::4.Displays prompt popup
::5.If selected "ok":
::  - Uses %SoundVolumeView% to switch default device to the other device
::  - Uses %SoundVolumeView% to set default volume to the other device's default volume
::  - Displays info popup for %TIMEOUT% seconds
::6.If selected "cancel":
::  - Exits
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
		set "DEVICE=%S_DEVICE%"
		set "VOLUME=%S_VOLUME%"
		set "INFO=%H_DEVICE% → %S_DEVICE%"
		GOTO DISPLAY
	)
)
for /f "delims=" %%a in ('%SoundVolumeView% /GetColumnValue %S_DEVICE% %COLUMN%') do (
	REM Speakers
	call if "%%a" == "%DEFAULT%" (
		set "DEVICE=%H_DEVICE%"
		set "VOLUME=%H_VOLUME%"
		set "INFO=%S_DEVICE% → %H_DEVICE%"
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
echo Prompt: %INFO%
CScript //nologo //E:JScript "%~F0" 0 "%INFO%"
::---------------------------------------------------------------------
:: Response. ok=1, cancel=2
if "%errorlevel%" == "1" (
	REM Switch & display device
	%SoundVolumeView% /SetDefault %DEVICE% all 
	%SoundVolumeView% /SetVolume %DEVICE% %VOLUME% 
	echo Switch: %INFO%
	CScript //nologo //E:JScript "%~F0" %TIMEOUT% %DEVICE% "switch"
) else ( 
	REM do nothing
	echo Cancelled switching. 
)

:END
goto :EOF
@end
//---------------------------------------------------------------------
// Start Cscript and display popup
if (WScript.Arguments.Unnamed.Count < 2) WScript.Quit(0);
var timeout = WScript.Arguments.Unnamed(0);
var text = WScript.Arguments.Unnamed(1);
var WshShell = WScript.CreateObject("WScript.Shell")
if (WScript.Arguments.Unnamed.Count > 2) {
	if (WScript.Arguments.Unnamed(2)=="err") 
		WScript.Quit (WshShell.Popup(text ,timeout ,"Error", 0+48))
	else if (WScript.Arguments.Unnamed(2)=="switch") 
		WScript.Quit (WshShell.Popup(text ,timeout ,"New default device", 0+64))
}
else
	WScript.Quit (WshShell.Popup(text ,timeout ,"Switch device?", 1+32))