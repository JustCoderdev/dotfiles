{ settings, lib, ... }:

{
	home.username = settings.username;
	home.homeDirectory = "/home/${settings.username}";


	# AAAA, fuck home-manager (enable when switching from 23.05 to 23.11)
	manual.html.enable = false;
	manual.manpages.enable = false;

	imports = [
		../../modules/user/dev/editor/neovim.nix

		../../modules/user/dev/clang.nix
		../../modules/user/dev/git.nix
		../../modules/user/dev/tmux.nix
		../../modules/user/dev/zsh.nix
	];


	nixpkgs.config = let pkgs = settings.special_pkgs; in {
		permittedInsecurePackages = pkgs.insecure;
		allowUnfreePredicate = pkg:
			builtins.elem (lib.getName pkg) pkgs.unfree;
	};

	programs.home-manager.enable = true;
	home.stateVersion = "23.11";
}
