{ lib, pkgs, ... }:

let
	profiles-list =
	[
		      "i3-desktop" # i3, i3status, fusuma
		"hyprland-desktop" # hyprland, waybar

		 "develop-environment" # alacritty, clang, emacs, git, neovim, zsh, ssh, tmux
		    "game-environment" # mangohud

		"ryuji" # firefox
	];
in

{
	options.jcconfs =
	{
		username = lib.mkOption {
			description = "Name of the primary user";
			type = lib.types.str;
		};

		has-de = lib.mkEnableOption "graphical applications or not";
		is-laptop = lib.mkEnableOption "laptop specific modules";

		profiles = lib.mkOption {
			description = "List of profiles to enable";
			type = lib.types.listOf (lib.types.enum profiles-list);
		};

		wallpapers_path = lib.mkOption {
			description = "Specify the wallpapers directory";
			type = lib.types.path;
		};

		theme =
		{
			name = lib.mkOption {
				description = "The theme name within the package";
				type = lib.types.nullOr lib.types.str;
				default = "Adwaita:dark";
			};
			package = lib.mkOption {
				description = "Package providing the theme";
				type = lib.types.package;
				default = pkgs.adwaita-icon-theme;
			};
		};
	};
}
