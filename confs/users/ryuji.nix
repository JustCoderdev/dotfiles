{ inputs, lib, pkgs, settings, wallpapers_path, ... }:

let
	modules = [
		"i3"
		# "hyprland"
		# "waybar"

		"neovim"
		"emacs"

		"alacritty"
		"clang"
		"git"
		"zsh"
	];


	standalone-modules = [
		"firefox"
		"tmux"
		"ssh"
	];

	toPathList = (ms: lib.lists.forEach ms (m: ../${m}/default.nix));
	toStandalonePathList = (ms: lib.lists.forEach ms (m: ../standalone/${m}.nix));
in

{
	imports = [ ]
		++ (toPathList modules)
		++ (toStandalonePathList standalone-modules);


	# --- enable when 23.05 => 23.11 --- #
	manual.html.enable = false;          #
	manual.manpages.enable = false;      #
	# ---------------------------------- #


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
