{ pkgs, config, lib, ... }:

let
	self-manifest = config.common.manifest.self;
in

{
	imports =
	[
		./thunar.nix
		./wayland.nix
		./xserver.nix
	];

	config = lib.mkIf (self-manifest.hardware.graphics.desktop-environment.enable)
	{
		environment.systemPackages =
		[
			(pkgs.writeShellScriptBin "refresh-displays" config.services.xserver.displayManager.setupCommands)
		];

		xdg =
		# TODO: Add desktop files
		# let
		# 	create-desktop-item = (
		# 		name:
		# 		pkgs.makeDesktopItem {
		# 			name = "${name}-desktop";
		# 			desktopName = name;
		# 			exec = "${pkgs.${name}}/bin/${name}";
		# 			terminal = false;
		# 		}
		# 	);
		# 	desktop-files =
		# 	{
		# 		alacritty = (create-desktop-item "alacritty");
		# 		emulsion = (create-desktop-item "alacritty");
		# 	};
		# in
		{
			# terminal-exec.settings = { default = };
			# mime.defaultApplications =
			# {
			# 	"image/*" = [
			# 	];
			# };

			portal =
			{
				enable = true;
				extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
				config.common.default = [ "gtk" ];
			};
		};

		services.xserver.displayManager.setupCommands =
		let
			xrandr = "${pkgs.xrandr}/bin/xrandr";
			grep = "${pkgs.gnugrep}/bin/grep";

			displays = lib.attrsets.mapAttrsToList
				(_: value: value)
				(self-manifest.hardware.graphics.displays);
		in
''
AVAILABLE_DISPLAYS=""

${
builtins.concatStringsSep "\n" (
	builtins.map  (
		{ identifier, resolution, position }:
		''
${xrandr} | ${grep} '${identifier} connected' > /dev/null
if [[ "''${?}" -eq 0 ]]; then
	echo -e "Display ${identifier} \033[32mconnected\033[0m"
	${xrandr} --output ${identifier} --mode ${resolution} --pos ${position} --rotate normal
	AVAILABLE_DISPLAYS="''${AVAILABLE_DISPLAYS},${identifier}"
else
	echo -e "Display ${identifier} \033[31mdisconnected\033[0m"
	${xrandr} --output ${identifier} --off
fi
''
	) displays
)
}

AVAILABLE_DISPLAYS="''${AVAILABLE_DISPLAYS:1}"

case $1
in
	surround)
		case $2
		in
			enable)
				if [ -n $AVAILABLE_DISPLAYS ];
				then
					${xrandr} --setmonitor surround auto $AVAILABLE_DISPLAYS
				else
					echo "No display has been found?"
					exit 1
				fi
			;;

			disable)
				${xrandr} --delmonitor surround
			;;

			*)
				if [ -n $2 ];
				then
					echo "Unknown option '$2', did you meant to write 'enable' or 'disable'?"
					exit 1
				else
					echo "Missing command, available are 'enable' and 'disable'"
				fi
			;;
		esac
	;;

	mirror)
		if [ ${toString (builtins.length displays)} -ne 2];
		then
			echo "Number of displays is not 2"
			exit 1
		else
			${xrandr} --output ${(builtins.elemAt displays 0).identifier} --same-as ${(builtins.elemAt displays 1).identifier}
		fi
	;;
esac
''
		;
	};
}
