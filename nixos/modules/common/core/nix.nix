{ config, lib, pkgs, settings, ... }:

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
				dates = "monthly";

				# Keep the last 5 generations
				options = "--delete-older-than 15d";
			};
			settings = {
				auto-optimise-store = true;
				allowed-users = [ "root" "${settings.username}" ];

				substituters = [
					# "https://cache.nixos.org/?priority=40"
					"http://${custom-sub-url}:${toString nix-serve-port}?priority=30"
				];
				trusted-substituters = [ custom-sub-url ];

				experimental-features = [ "nix-command" "flakes" ];
				warn-dirty = false;
			};
			extraOptions = ''
fallback = true      # Nix will fall back to building from source if a binary substitute fails
connect-timeout = 5  # The timeout (in seconds) for establishing connections in the binary cache substituter
'';
		};

		services.journald.extraConfig = "SystemMaxUse=1G";

# Substituters helpful links
#   - Nix-keeps-trying-removed-substituter <https://discourse.nixos.org/t/nix-keeps-trying-removed-substituter/39809/3>
#   - The build fails if a build machine/cache is offline <https://github.com/NixOS/nix/issues/3514>


		services.nix-serve = {
			enable = cfg.serve-store.enable;
			openFirewall = true;
			port = nix-serve-port;
		};

		environment.variables = {
			"DOT_NIX_SUB_URL" = "${custom-sub-url}";
			"DOT_NIX_SUB_PORT" = "${toString nix-serve-port}";
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
