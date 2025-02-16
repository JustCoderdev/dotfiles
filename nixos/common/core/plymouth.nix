{ pkgs, config, lib, settings, ... }:

let
	i3 = config.system.desktop.xfce;
	hyprland = config.system.desktop.hyprland;
in

{
	# Check what VGA graphics driver is installed
	# lspci -v | grep -A10 VGA | grep driver

	boot.initrd.systemd.enable = true;
	boot.kernelParams = [
		"quiet" "splash"
		#"plymouth.debug" # log at /var/log/plymouth-debug.log
	];

	boot.plymouth = lib.mkIf (!settings.runningVM && (i3.enable || hyprland.enable) ) {
		enable = true;

		theme = "darnix";
		themePackages = [ pkgs.darnix-theme ];
	};
}
