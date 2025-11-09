{ config, lib, pkgs, pkgs-unstable, settings, inputs, ... }:

let
	inherit (settings) system hardware-type;

	cfg = config.system.desktop.i3;
in

{
	config = lib.mkIf (cfg.enable)
	{
		system.nixos.tags = [ "i3" ];

		services =
		{
			displayManager.defaultSession = "none+i3";

			xserver.windowManager.i3 =
			{
				enable = true;
				extraPackages = [ inputs.jcbin.packages."${system}".boomer ]
				++ 
				(
					with pkgs;
					[
						dmenu i3status playerctl lightdm # dm-tool lock
						shotgun xclip # Screenshot utilities
						(
							callPackage ../../../unofficial/pkgs/hacksaw.nix {
								inherit (pkgs) python3; # pkg-config
								inherit (pkgs.xorg) libX11 libXrandr;
								inherit (pkgs-unstable) libxcb;
							}
						)
					]
				);
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.desktop.i3 =
	{
		enable = lib.mkEnableOption "i3 tiling window manager support";
	};
}
