{ inputs, config, lib, pkgs, settings, ... }:

let
	inherit (settings) special-pkgs;
	inherit (config.jcconfs) username;

	cfg = config.jcconfs;

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
	imports = 
	[
		inputs.stylix.homeModules.stylix
		./stylix/default.nix
	];

	config =
	{
		# --- enable when 23.05 => 23.11 --- #
		manual.html.enable = false;          #
		manual.manpages.enable = false;      #
		# ---------------------------------- #


		# DO NOT TOUCH
		nixpkgs.config = {
			permittedInsecurePackages = special-pkgs.insecure;
			allowUnfreePredicate = pkg:
				builtins.elem (lib.getName pkg) special-pkgs.unfree;
		};

		programs.home-manager.enable = true;
		home = {
			inherit username;
			homeDirectory = "/home/${username}";
			stateVersion = "23.11";
		};
	};

	# ------------------------------------------------------------ #

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
			type = lib.types.listOf lib.types.enum profiles-list;
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
