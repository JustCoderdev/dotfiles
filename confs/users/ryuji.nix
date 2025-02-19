{ inputs, lib, pkgs, settings, wallpapers_path, ... }:

let
	modules = [
		"i3"
		"hyprland"
		"waybar"

		"neovim"
		"emacs"

		# "alacritty"
		"clang"
		"git"
		"zsh"
	];


	standalone-modules = [
		"firefox"
		"gtk"
		"tmux"
	];

	toPathList = (ms: lib.lists.forEach ms (m: ../${m}/default.nix));
	toStandalonePathList = (ms: lib.lists.forEach ms (m: ../standalone/${m}.nix));
in

{
	imports = [ inputs.stylix.homeManagerModules.stylix ]
		++ (toPathList modules)
		++ (toStandalonePathList standalone-modules);


	# --- enable when 23.05 => 23.11 --- #
	manual.html.enable = false;          #
	manual.manpages.enable = false;      #
	# ---------------------------------- #


	# <https://youtu.be/ljHkWgBaQWU?si=GgoH0R7OykG20Se2>
	stylix = {
		enable = true;

		polarity = "dark";
		base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
		image = "${wallpapers_path}/space_engineers.png";

		iconTheme = {
			enable = true;
			package = pkgs.adwaita-icon-theme;
			dark = "Adawaita";
		};

		cursor = {
			name = "Adwaita";
			package = pkgs.adwaita-icon-theme;
			size = 32;
		};

		targets = {
			# alacritty.enable = false;
			neovim.enable = false;
			waybar.enable = false;
		};

		fonts = {
			sizes = {
				applications = 12;
				terminal = 15;
				desktop = 10;
				popups = 10;
			};

			monospace = {
				name = "DejaVu Sans Mono";
				package = pkgs.dejavu_fonts;
			};
			sansSerif = {
				name = "DejaVu Sans";
				package = pkgs.dejavu_fonts;
			};
			serif = {
				name = "DejaVu Serif";
				package = pkgs.dejavu_fonts;
			};
		};
	};


	# DO NOT TOUCH
	nixpkgs.config = let pkgs = settings.special_pkgs; in {
		permittedInsecurePackages = pkgs.insecure;
		allowUnfreePredicate = pkg:
			builtins.elem (lib.getName pkg) pkgs.unfree;
	};

	programs.home-manager.enable = true;
	home = {
		username = settings.username;
		homeDirectory = "/home/${settings.username}";
		stateVersion = "23.11";
	};
}
