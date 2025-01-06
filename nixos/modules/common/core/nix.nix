{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.core.nix;
	nix-serve-port = 56552;
	custom-sub-url = "http://nixcache.local:${toString nix-serve-port}";
in

{
	options.common.core.nix = {
		serve-store.enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable nix-store service";
			default = false;
		};
	};

	config = {
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
				allowed-users = [ "root" "${settings.username}" ];

				substituters = [
					# "https://cache.nixos.org/?priority=40"
					"${custom-sub-url}?priority=50"
				];
				trusted-substituters = [ custom-sub-url ];

				experimental-features = [ "nix-command" "flakes" ];
				warn-dirty = false;
			};
			extraOptions = ''
narinfo-cache-positive-ttl = 0
narinfo-cache-negative-ttl = 0
'';
		};

		services.journald.extraConfig = "SystemMaxUse=1G";

		services.nix-serve = {
			enable = cfg.serve-store.enable;
			openFirewall = true;
			port = nix-serve-port;
		};

		environment.variables = {
			"DOT_NIX_SUB" = custom-sub-url;
		};

		programs.nix-ld = {
			enable = true;
			libraries = [ pkgs.glibc ];
		};

		nixpkgs.config = let pkgs = settings.special_pkgs; in {
			permittedInsecurePackages = pkgs.insecure;
			allowUnfreePredicate = pkg:
				builtins.elem (lib.getName pkg) pkgs.unfree;
		};
	};

}
