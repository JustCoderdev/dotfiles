{ config, lib, pkgs, ... }:

let
	cfg = config.jcconfs;
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

		targets = 
		{
			alacritty.enable = false;
			neovim.enable = false;
			emacs.enable = false;

			mangohud.enable = false;

			hyprland.enable = false;
			waybar.enable = false;

			firefox.profileNames = [ "${cfg.username}" ];
		};
	};
}
