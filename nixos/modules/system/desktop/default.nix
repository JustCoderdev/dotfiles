{ pkgs, config, lib, settings, ... }:

let
#	nvidia = config.common.core.nvidia;
#	video-editing = config.common.users.ryuji.video-editing;

	i3 = config.system.desktop.xfce;
	hyprland = config.system.desktop.hyprland;
in

{
	imports = [
		../../unofficial/fusuma.nix
		./xserver
		./wayland
	];

	config = lib.mkIf (i3.enable or hyprland.enable) {
		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-kde
				xdg-desktop-portal-gtk
			];
			config.common.default = [ "gtk" ];
		};

		hardware.graphics = {
			enable = true;
			enable32Bit = true;

#			extraPackages = [
#				(lib.mkIf video-editing pkgs.intel-compute-runtime)
#			];
		};


		services.fusuma = let
			prefix = if i3.enable then "i3"
				else if hyprland.enable then "hyprland"
				else abort "Fusuma: no desktop environment enabled";
		in {
			enable = true;
			settings = (builtins.readFile
				 "${settings.dotfiles_path}/fusuma/${prefix}_config.yml");
		};

		environment.systemPackages = [
			(lib.mkIf i3.enable       pkgs.xdotool)
			(lib.mkIf hyprland.enable pkgs.ydotool)
		];
	};
}
