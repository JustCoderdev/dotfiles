{ inputs, lib, pkgs, settings, ... }:

let
	inherit (settings) username special-pkgs;

	modules =
	[
		"alacritty"
		"clang"
		"emacs"
		"git"
		"hyprland"
		"i3"
		"mangohud"
		"neovim"
		"waybar"
		"zsh"
	];

	standalone-modules =
	[
		"firefox"
		"fusuma"
		"ssh"
		"tmux"
	];

	toPathList = (ms: lib.lists.forEach ms (m: ./modules/${m}/default.nix));
	toStandalonePathList = (ms: lib.lists.forEach ms (m: ./standalone/${m}.nix));
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
}
