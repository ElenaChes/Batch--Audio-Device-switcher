# Audio Device switcher

An audio device switcher written in Batch and Cscript using [SoundVolumeView](https://www.nirsoft.net/utils/sound_volume_view.html).<br>
Description: a collection of scripts that can set the default audio device, check what is the current default audio device, or switch between 2 devices.

<details>
  <summary><h3>Content</h3></summary>

- [Dependencies](#dependencies)
- [Installation](#installation)
- [Scripts](#scripts)
  - [CheckDevice.bat](#checkdevicebat)
  - [SwitchDevice.bat](#switchdevicebat)
  - [SwitchHeadset.bat](#switchheadsetbat)
  - [SwitchSpeakers.bat](#switchspeakersbat)
- [Usage](#usage)

</details>
<hr>

# Dependencies

1. SoundVolumeCommandLine v1.25 by Nir Sofer - [Website](https://www.nirsoft.net/utils/sound_volume_command_line.html).

The scripts could work with different versions, but that is the ones that was tested.

# Installation

1. Download and unpack the dependency.
2. Download the desired scripts and `variables.csv`

> [!TIP]
> Place the files in the same folder as `svcl.exe` for ease of use.

3. Update `variables.csv` file so it fits your needs:

```
SoundVolumeView,<relative path to svcl.exe>
TIMEOUT,<how many seconds information popups wait before automatically closing>
COLUMN,<name of the column in SoundVolumeView that indicates your default device>
DEFAULT,<keyword that appears in COLUMN for your default device>
S_DEVICE,<name of 1st audio device>
H_DEVICE,<name of 2nd audio device>
S_VOLUME,<default volume for 1st device>
H_VOLUME,<default volume for 2nd device>
```

> [!NOTE]
> Notice that the variables are currently set to switch between a Headset and Speakers, so the comments in the code and file names reflect that, but you could use these scripts to switch between any 2 devices.

# Scripts

## CheckDevice.bat

Checks which audio device (out of 2 options) is currently set as default and displays the information in a popup. If it's neither an error message will be displayed.

### Required variables:

- SoundVolumeView, TIMEOUT, COLUMN, DEFAULT, H_DEVICE, S_DEVICE

### Script behaviour:

1. Reads variables from `VARS_PATH` (relative path to `variables.csv`, declared inside the script)
2. Uses `SoundVolumeView` to get the value of `COLUMN` for `S_DEVICE` and `H_DEVICE`.
3. Finds which device's state is set to the `DEFAULT` keyword.
4. Displays info popup for `TIMEOUT` seconds.

## SwitchDevice.bat

Checks which audio device (out of 2 options) is currently set as default , sets the other device to default and displays the information in a popup. If it's neither an error message will be displayed.

### Required variables:

- SoundVolumeView, TIMEOUT, COLUMN, DEFAULT, H_DEVICE, S_DEVICE, H_VOLUME, S_VOLUME

### Script behaviour:

1. Reads variables from `VARS_PATH` (relative path to `variables.csv`, declared inside the script)
2. Uses `SoundVolumeView` to get the value of `COLUMN` for `S_DEVICE` and `H_DEVICE`.
3. Finds which device's state is set to the `DEFAULT` keyword.
4. Uses `SoundVolumeView` to switch default device to the other device.
5. Uses `SoundVolumeView` to set default volume to the other device's default volume.
6. Displays info popup for `TIMEOUT` seconds.

## SwitchHeadset.bat

Sets `H_DEVICE` audio device to default regardless of the current default device and displays the information in a popup.

### Required variables:

- SoundVolumeView, TIMEOUT, H_DEVICE, H_VOLUME

### Script behaviour:

1. Reads variables from `VARS_PATH` (relative path to `variables.csv`, declared inside the script)
2. Uses `SoundVolumeView` to switch default device to `H_DEVICE`.
3. Uses `SoundVolumeView` to set default volume to `H_VOLUME`.
4. Displays info popup for `TIMEOUT` seconds.

## SwitchSpeakers.bat

Sets `S_DEVICE` audio device to default regardless of the current default device and displays the information in a popup.

### Required variables:

- SoundVolumeView, TIMEOUT, S_DEVICE, S_VOLUME

### Script behaviour:

1. Reads variables from `VARS_PATH` (relative path to `variables.csv`, declared inside the script)
2. Uses `SoundVolumeView` to switch default device to `S_DEVICE`.
3. Uses `SoundVolumeView` to set default volume to `S_VOLUME`.
4. Displays info popup for `TIMEOUT` seconds.

# Usage

1. Run the desired script to switch/check your default audio device .

> [!TIP]
> Create a shortcut to a script on your desktop, open its properties and change `Run` to `Minimized`, that'll enable it to run in the background and only display the end result. Run the script via the shortcut instead of running the file directly.

> [!TIP]
> If your keyboard or mouse has programmable buttons you can set some to run your shortcut(s) to switch/check audio device without needing to go to your desktop.
