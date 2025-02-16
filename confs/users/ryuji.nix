{ settings, lib, ... }:

let
	modules = [
		"i3"
		"hyprland"
		"waybar"

		"neovim"
		"emacs"

		"alacritty"
		"clang"
		"git"
		"zsh"
	];


	standalone-modules = [
		"firefox"
		"gtk"
		"tmux"
	];

	toPathList = (ms: lib.lists.forEach ms (m: ./${m}/default.nix));
	toStandalonePathList = (ms: lib.lists.forEach ms (m: ./standalone/${m}.nix));
in

{
	home = {
		username = settings.username;
		homeDirectory = "/home/${settings.username}";
		stateVersion = "23.11";
	};

	imports = (toPathList modules)
		++ (toStandalonePathList standalone-modules);

	# enable when switching from 23.05 to 23.11
	manual.html.enable = false;
	manual.manpages.enable = false;
	# ----------------------------- #

	nixpkgs.config = let pkgs = settings.special_pkgs; in {
		permittedInsecurePackages = pkgs.insecure;
		allowUnfreePredicate = pkg:
			builtins.elem (lib.getName pkg) pkgs.unfree;
	};

	programs.home-manager.enable = true;
}
