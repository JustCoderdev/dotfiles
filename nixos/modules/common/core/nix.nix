{ lib, pkgs, settings, ... }:

{
	nix = {
		optimise.automatic = true;
		gc = {
			automatic = true;
			dates = "weekly";

			# Keep the last 5 generations
			options = "--delete-older-than +5";
		};
		settings = {
			auto-optimise-store = true;
			allowed-users = [ "root" "@wheel" ];

			experimental-features = [ "nix-command" "flakes" ];
			warn-dirty = false;
		};
	};

	services.journald.extraConfig = "SystemMaxUse=1G";
	programs.nix-ld = {
		enable = true;
		libraries = [ pkgs.glibc ];
	};

	nixpkgs.config = let pkgs = settings.special_pkgs; in {
		permittedInsecurePackages = pkgs.insecure;
		allowUnfreePredicate = pkg:
			builtins.elem (lib.getName pkg) pkgs.unfree;
	};
}
