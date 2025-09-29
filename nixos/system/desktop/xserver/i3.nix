{ inputs, config, lib, pkgs, pkgs-unstable, settings, ... }:

let
	cfg = config.system.desktop.i3;
in

{
	config = lib.mkIf cfg.enable
	{
		system.nixos.tags = [ "i3" ];

		services = {
			displayManager.defaultSession = "none+i3";

			xserver.windowManager.i3 = {
				enable = true;
				extraPackages = [ inputs.jcbin.packages."${settings.system}".boomer ]
				++ 
				(
					with pkgs;
					[
						dmenu
						i3status
						playerctl

						# Screenshot utilities
						(
							callPackage ../../../unofficial/pkgs/hacksaw.nix {
								inherit (pkgs) python3; # pkg-config
								inherit (pkgs.xorg) libX11 libXrandr;
								inherit (pkgs-unstable) libxcb;
							}
						)
						shotgun
						xclip
					]
				);
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.desktop.i3 =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable i3 software suit and support";
			default = false;
		};
	};
}
