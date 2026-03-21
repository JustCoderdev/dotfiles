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
			xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
			grep = "${pkgs.gnugrep}/bin/grep";
		in
''
AVAILABLE_DISPLAYS=""

${
builtins.concatStringsSep "\n" (
	lib.attrsets.mapAttrsToList  (
		name: value:
		''
${xrandr} | ${grep} '${value.identifier} connected' > /dev/null
if [[ "''${?}" -eq 0 ]]; then
	echo -e "Display ${value.identifier} \033[32mconnected\033[0m"
	${xrandr} --output ${value.identifier} --mode ${value.resolution} --pos ${value.position} --rotate normal
	AVAILABLE_DISPLAYS="''${AVAILABLE_DISPLAYS},${value.identifier}"
else
	echo -e "Display ${value.identifier} \033[31mdisconnected\033[0m"
	${xrandr} --output ${value.identifier} --off
fi
''
	) self-manifest.hardware.graphics.displays
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
				fi
			;;

			disable)
				${xrandr} --delmonitor surround
			;;

			*)
				if [ -n $2 ];
				then
					echo "Unknown option '$2', did you meant to write 'enable' or 'disable'?"
				else
					echo "Missing command, available are 'enable' and 'disable'"
				fi
			;;
		esac
	;;
esac
''
		;
	};
}
