{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.services.nixcache;
	secrets = config.common.core.secrets;
	instance-url =  "http://${cfg.instance-host}:${toString cfg.instance-port}?priority=30";
in

{
	# Substituters guides
	# - Nix-keeps-trying-removed-substituter <https://discourse.nixos.org/t/nix-keeps-trying-removed-substituter/39809/3>
	# - The build fails if a build machine/cache is offline <https://github.com/NixOS/nix/issues/3514>

	config =
	{
		networking.firewall.allowedTCPPorts = lib.optionals (cfg.enable) [ cfg.instance-port ];

		services.nix-serve = {
			inherit (cfg) enable port;
			package = pkgs.nix-serve-ng;

			openFirewall = true;
			# old "/var/cache-priv-key.pem";
			secretKeyFile = secrets.nix-serve.priv-key.path;
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

	# ------------------------------------------------------------ #

	options.system.services.nixcache =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable nixcache daemon";
			default = false;
		};
		port = lib.mkOption {
			type = lib.types.port;
			description = "Nixcache daemon port";
			default = 56552;
		};
		instance-host = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			description = "Local nixcache host";
			default = null;
		};
		instance-port = lib.mkOption {
			type = lib.types.port;
			description = "Local nixcache port";
			default = 56552;
		};
	};
}

