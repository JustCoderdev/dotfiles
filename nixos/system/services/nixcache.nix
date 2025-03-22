{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.services.nixcache;
	instance-url =  "http://${cfg.instance-host}:${toString cfg.instance-port}?priority=30";
in

{
	# Substituters guides
	# - Nix-keeps-trying-removed-substituter <https://discourse.nixos.org/t/nix-keeps-trying-removed-substituter/39809/3>
	# - The build fails if a build machine/cache is offline <https://github.com/NixOS/nix/issues/3514>

	config = {
		services.nix-serve = {
			inherit (cfg) enable port;
			package = pkgs.nix-serve-ng;

			openFirewall = true;
			secretKeyFile = "/var/cache-priv-key.pem";
		};

		nix.settings = {
			allowed-users = lib.optionals (cfg.enable) [ "nix-serve" ];

			substituters = [ ]
				++ lib.optionals (cfg.instance-host != null) [ instance-url ];

			# trusted-substituters = [ ]
			# 	++ lib.optional (cfg.instance-host != null) [ instance-url ];
			# trusted-public-keys = [
			# 	"nixcache.local:K7HJMUeafG+hmi6ZoLRJ+/sjt8TZyCvmHe0zrRPio5w="
			# ];
		};

		environment.variables = { }
			// lib.attrsets.optionalAttrs (cfg.instance-host != null)
			{
				DOT_NIX_SUB_URL  = "${cfg.instance-host}";
				DOT_NIX_SUB_PORT = "${toString cfg.instance-port}";
			};
	};
}

