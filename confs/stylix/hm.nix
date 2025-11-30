{ config, ... }:

let
	inherit (config.home) username;
	cfg = config.jcconfs;
in

{
	stylix =
	{
		icons = {
			enable = true;
			inherit (cfg.icon-theme) package;
			light = cfg.icon-theme.name;
			dark = cfg.icon-theme.name;
		};

		autoEnable = true;

		targets =
		{
			# alacritty.enable = false;
			neovim.enable = false;
			emacs.enable = false;

			mangohud.enable = false;

			hyprland.enable = false;
			waybar.enable = false;

			firefox.profileNames = [ "${username}" ];
		};
	};
}
