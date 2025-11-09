{ lib, writeShellScriptBin, curl }:

let
	add-command = (
		name: par1: par2: opt: description:
		{
			inherit name description;
			getCommand = pwd: "http://10.5.5.9/${par1}/${par2}?t=${pwd}&p=%${opt}";
		}
	);

	gopro-commands = 
	[
		# Commands taken from PyHero
		# Source <https://github.com/Splinter0/PyHero>
		(add-command "power_off"         "bacpac" "PW" "00" "Turn off your camera")
		(add-command "power_on"          "bacpac" "PW" "01" "Turn on your camera")

		(add-command "recording_stop"    "bacpac" "SH" "00" "Stop recording")
		(add-command "recording_start"   "bacpac" "SH" "01" "Emulate the shoot button (start video, take pic, ecc..)")

		(add-command "leds_off"          "bacpac" "LB" "00" "Turn off all the leds on your camera")
		(add-command "leds_2"            "camera" "LB" "01" "Switch 2 leds on")
		(add-command "leds_4"            "camera" "LB" "02" "Switch 4 leds on")

		(add-command "preview_off"       "camera" "PV" "00" "Turn preview mode off")
		(add-command "preview_on"        "camera" "PV" "02" "Turn preview mode on")

		(add-command "mode_video"        "camera" "CM" "00" "Put your camera in video mode")
		(add-command "mode_photo"        "camera" "CM" "01" "Put your camera in photo mode")
		(add-command "mode_brust"        "camera" "CM" "02" "Put your camera in brust mode")
		(add-command "mode_timelapse"    "camera" "CM" "03" "Put your camera in timelapse mode")
		(add-command "mode_timer"        "camera" "CM" "04" "Put your camera in timer mode")
		(add-command "mode_play_hdmi"    "camera" "CM" "05" "Put your camera in play mode (if connected to monitor)")

		(add-command "orientation_up"    "camera" "UP" "00" "Move the camera orientation up")
		(add-command "orientation_down"  "camera" "UP" "01" "Move the camera orientation down")

		(add-command "fov_wide"          "camera" "FV" "00" "Put the FOV in wide mode")
		(add-command "fov_medium"        "camera" "FV" "01" "Put the FOV in medium mode")
		(add-command "fov_narrow"        "camera" "FV" "02" "Put the FOV in narrow mode")

		(add-command "volume_0"          "camera" "BS" "00" "Put the volume to 0%")
		(add-command "volume_70"         "camera" "BS" "01" "Put the volume to 70%")
		(add-command "volume_100"        "camera" "BS" "02" "Put the volume to 100%")

		(add-command "protune_on"        "camera" "PT" "00" "Turn the protune mode on")
		(add-command "protune_off"       "camera" "PT" "01" "Turn the protune mode off")

		(add-command "autopoweroff_no"   "camera" "AO" "00" "Disable autopoweroff")
		(add-command "autopoweroff_60s"  "camera" "AO" "01" "Set autopoweroff to 60s")
		(add-command "autopoweroff_120s" "camera" "AO" "02" "Set autopoweroff to 120s")
		(add-command "autopoweroff_300s" "camera" "AO" "03" "Set autopoweroff to 300s")
	];
in

writeShellScriptBin "gopro-control" ''
arg=$1

case "''${arg}" in

	'help' | '--help' | '-h')
${
	lib.strings.concatStrings (
		builtins.map (
			{ name, description, ... }:
			let
				spaces = "                     ";
				len = str: builtins.stringLength str;
				getAlign = count: builtins.substring 0 ((len spaces) - count) spaces;
			in
			"\t\techo \"${name}${getAlign (len name)}${description}\";\n"
		) gopro-commands
	)
}		;;

${
	lib.strings.concatStrings (
		builtins.map (
			{ name, description, getCommand }:
''	'${name}')
		echo '${description}'
		echo -n '[gopro] Password: '
		read -s password
		echo
		echo "Executing 'curl ${getCommand "pwd"}'"
		${curl}/bin/curl -s --output /dev/null "${getCommand "\${password}"}"
		echo $?
		;;

''
		) gopro-commands
	)
}	*)
		echo "Unknown argument ''${arg}, see 'help'"
		;;
esac
''
