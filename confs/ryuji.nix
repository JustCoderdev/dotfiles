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

	lib = nixpkgs.lib

	toPathList = (ms: lib.lists.forEach ms (m: ./${m}/default.nix));
in

{
	home = {
		username = settings.username;
		homeDirectory = "/home/${settings.username}";
	};

	# enable when switching from 23.05 to 23.11
	manual.html.enable = false;
	manual.manpages.enable = false;

	imports = toPathList modules;

	# tmux.nix
	# firefox.nix
	# gtk.nix


	nixpkgs.config = let pkgs = settings.special_pkgs; in {
		permittedInsecurePackages = pkgs.insecure;
		allowUnfreePredicate = pkg:
			builtins.elem (lib.getName pkg) pkgs.unfree;
	};

	programs.home-manager.enable = true;
	home.stateVersion = "23.11";
}
