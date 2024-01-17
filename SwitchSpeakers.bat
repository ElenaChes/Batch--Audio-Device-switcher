@if (@CodeSection == @Batch) @then
@echo off
setlocal
set "VARS_PATH=variables.csv"
::---------------------------------------------------------------------
::1.Reads variables from %VARS_PATH%
::--Required vars: SoundVolumeView, TIMEOUT, S_DEVICE, S_VOLUME--
::2.Uses %SoundVolumeView% to switch default device to %S_DEVICE%
::3.Uses %SoundVolumeView% to set default volume to %S_VOLUME%
::4.Displays info popup for %TIMEOUT% seconds
::---------------------------------------------------------------------
:: Default variables
for /f "tokens=1, 2 delims=," %%a in ('type %VARS_PATH%') do (
	if %%a NEQ "" if %%b NEQ "" ( set "%%a=%%b" )
)
::---------------------------------------------------------------------
:: Switch any -> Speakers
%SoundVolumeView% /SetDefault %S_DEVICE% all 
%SoundVolumeView% /SetVolume %S_DEVICE% %S_VOLUME% 
::---------------------------------------------------------------------
:: Display device
echo Set: %S_DEVICE%
CScript //nologo //E:JScript "%~F0" %TIMEOUT% %S_DEVICE%

goto :EOF
@end
//---------------------------------------------------------------------
// Start Cscript and display popup
if (WScript.Arguments.Unnamed.Count < 2) WScript.Quit(0);
var timeout = WScript.Arguments.Unnamed(0);
var text = WScript.Arguments.Unnamed(1);
var WshShell = WScript.CreateObject("WScript.Shell")
WScript.Quit (WshShell.Popup(text ,timeout ,"New default device", 0+64))