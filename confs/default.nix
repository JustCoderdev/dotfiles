{ inputs, lib, pkgs, settings, ... }:

let
	inherit (settings) username special-pkgs;

	modules = [
		"i3"
		# "hyprland"
		# "waybar"

		"mangohud"

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

	toPathList = (ms: lib.lists.forEach ms (m: ./${m}/default.nix));
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
