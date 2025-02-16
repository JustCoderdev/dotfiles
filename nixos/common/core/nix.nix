{ config, lib, pkgs, settings, darnix-overlay, ... }:

let
	cfg = config.common.core.nix;
	nix-serve-port = 56552;
	custom-sub-url = "nixcache.local";
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
				dates = "17:30";

				# Keep the last 5 generations
				options = "--delete-older-than 15d";
			};

			settings = {
				auto-optimise-store = true;
				allowed-users = [
					"${settings.username}"
					"nix-serve"
				];

				substituters = [
					# "https://cache.nixos.org/?priority=40"
					# "http://${custom-sub-url}:${toString nix-serve-port}?priority=30"
				];
				trusted-substituters = [ custom-sub-url ];
				trusted-public-keys = [
					"nixcache.local:K7HJMUeafG+hmi6ZoLRJ+/sjt8TZyCvmHe0zrRPio5w="
				];

				experimental-features = [ "nix-command" "flakes" ];
				warn-dirty = false;
			};
			extraOptions = ''
				# Options can be found at <https://nix.dev/manual/nix/2.24/command-ref/conf-file>
				fallback = true                # Nix will fall back to building from source if a binary substitute fails
				connect-timeout = 2            # The timeout (in seconds) for establishing connections in the binary cache substituter
				narinfo-cache-positive-ttl = 0 # If a store path is queried from a substituter, the result of the query will be cached in the local disk cache database including some of the NAR metadata
				narinfo-cache-negative-ttl = 0 # If a store path is queried from a substituter but was not found, there will be a negative lookup cached in the local disk cache database for the specified duration
			'';
		};

		services.journald.extraConfig = "SystemMaxUse=1G";

# Substituters helpful links
#   - Nix-keeps-trying-removed-substituter <https://discourse.nixos.org/t/nix-keeps-trying-removed-substituter/39809/3>
#   - The build fails if a build machine/cache is offline <https://github.com/NixOS/nix/issues/3514>


		services.nix-serve = {
			enable = cfg.serve-store.enable;
			package = pkgs.nix-serve-ng;

			openFirewall = true;
			port = nix-serve-port;

			secretKeyFile = "/var/cache-priv-key.pem";
		};

		# environment.variables = lib.mkIf (!cfg.serve-store.enable) {
		# 	"DOT_NIX_SUB_URL" = "${custom-sub-url}";
		# 	"DOT_NIX_SUB_PORT" = "${toString nix-serve-port}";
		# };

		programs.nix-ld = {
			enable = true;
			libraries = [ pkgs.glibc ];
		};

		nixpkgs = {
			overlays = [ darnix-overlay ];
			config = let pkgs = settings.special_pkgs; in {
				permittedInsecurePackages = pkgs.insecure;
				allowUnfreePredicate = pkg: builtins.elem
					(nixpkgs.lib.getName pkg) pkgs.unfree;
			};
		};
	};
}
