{ lib, pkgs, ... }:

let
	profiles-list =
	[
		      "i3-desktop" # i3, i3status, fusuma
		"hyprland-desktop" # hyprland, waybar

		 "develop-environment" # alacritty, emacs, git, neovim, zsh, ssh
		    "game-environment" # mangohud

		"ryuji-user" # firefox
	];
in

{
	options.jcconfs =
	{
		# -------------------- #

		host = {
			has-de = lib.mkEnableOption "graphical applications or not";
			is-laptop = lib.mkEnableOption "laptop specific modules";
		};

		# -------------------- #

		users = lib.mkOption {
			description = "User preferences";
			type = lib.types.attrsOf
			(
				lib.types.submodule
				(
					{ name, ... }:
					{
						options =
						{
							username = lib.mkOption {
								description = "The name of the user";
								type = lib.types.str;
								default = name;
								readOnly = true;
							};

							profiles = lib.mkOption {
								description = "List of profiles to enable";
								type = lib.types.listOf (lib.types.enum profiles-list);
							};

							special-pkgs =
							{
								insecure = lib.mkOption {
									description = "List of allowed insecure packages";
									type = lib.types.listOf lib.types.str;
								};
								unfree = lib.mkOption {
									description = "List of allowed unfree packages";
									type = lib.types.listOf lib.types.str;
								};
							};
						};
					}
				)
			);
		};

		# -------------------- #

		wallpapers_path = lib.mkOption {
			description = "Specify the wallpapers directory";
			type = lib.types.path;
		};

		# -------------------- #

		icon-theme =
		{
			name = lib.mkOption {
				description = "The theme name within the package";
				type = lib.types.nullOr lib.types.str;
				default = "Adwaita:dark";
				readOnly = true;
			};
			package = lib.mkOption {
				description = "Package providing the theme";
				type = lib.types.package;
				default = pkgs.adwaita-icon-theme;
				readOnly = true;
			};
		};
	};
}
