{ lib, pkgs, ... }:

{
	imports = [ ./x11.nix ];

	# Remember windows size stuff
	programs.dconf.enable = true;

	services.xserver = {
		displayManager.defaultSession = lib.mkForce "none+i3";

		windowManager.i3 = {
			enable = true;
			extraPackages = with pkgs; [
				dmenu
				i3status
				playerctl
				# i3lock
			];
		};
	};
}
