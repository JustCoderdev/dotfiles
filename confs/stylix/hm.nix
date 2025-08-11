{ config, lib, pkgs, settings, ... }:

{
	stylix =
	{
		iconTheme = {
			enable = true;
			package = pkgs.adwaita-icon-theme;
			dark = "Adawaita";
		};

		autoEnable = true;

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
