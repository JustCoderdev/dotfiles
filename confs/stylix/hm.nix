{ config, lib, pkgs, ... }:

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

	xdg.dataFile."themes/Stylix/gnome-shell/gnome-shell.css".source =
	(
		let theme = pkgs.callPackage ./gnome-fix/gnome-theme.nix { inherit (config.stylix) inputs; inherit (config.lib.stylix) colors; }; in
		lib.mkForce "${theme}/share/gnome-shell/gnome-shell.css"
	);
}
