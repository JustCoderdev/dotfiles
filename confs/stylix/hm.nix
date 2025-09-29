{ config, lib, pkgs, settings, ... }:

let
	cfg = config.stylix.module;
in

{
	stylix =
	{
		icons = {
			enable = true;
			inherit (cfg.theme) package;
			light = cfg.theme.name;
			dark = cfg.theme.name;
		};

		autoEnable = true;

		targets = {
			alacritty.enable = false;
			neovim.enable = false;
			waybar.enable = false;
			emacs.enable = false;

			hyprland.enable = lib.mkForce false;
			hyprpaper.enable = lib.mkForce false;
			hyprlock.enable = lib.mkForce false;

			firefox.profileNames = [ "${settings.username}" ];
		};
	};
}
