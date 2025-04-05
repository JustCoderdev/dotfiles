{ config, lib, pkgs, ... }:

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
				extraPackages = with pkgs; [
					dmenu
					i3status
					playerctl
					CuboCore.coreshot
				];
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.desktop.i3 =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable i3 software suit and support";
			default = true;
		};
	};
}
