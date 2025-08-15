{ config, lib, pkgs, settings, ... }:

let
	cfg = config.stylix.module;
in

{
	stylix = lib.mkIf (cfg.has_de)
	{
		iconTheme = {
			enable = true;
			package = pkgs.adwaita-icon-theme;
			dark = "Adawaita";
		};

		targets = {
			alacritty.enable = false;
			i3.enable = false;
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
