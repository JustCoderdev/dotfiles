{ lib, pkgs, settings, ... }:

let
	nix-serve-port = 56552;
in

{
	system.nixos.tags = [ "${settings.hostname}" ];

	nix = {
		optimise.automatic = true;
		gc = {
			automatic = true;
			dates = "monthly";

			# Keep the last 5 generations
			options = "--delete-older-than 15d";
		};
		settings = {
			auto-optimise-store = true;
			allowed-users = [ "root" "@wheel" ];
			substituters = [
				"http://nixcache.local:${toString nix-serve-port}"
				"https://cache.nixos.org/"
			];

			experimental-features = [ "nix-command" "flakes" ];
			warn-dirty = false;
		};
	};

#	boot.loader.grub.extraEntries = ''
## Power options
#menuentry "Reboot" {
#	reboot
#}
#
#menuentry "Shutdown" {
#	halt
#}
#'';

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
