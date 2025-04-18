{ config, lib, pkgs, settings, darnix-overlay, ... }:

let
	cfg = config.common.core.nix;
in

{
	config = {
		system.nixos.tags = [ "${settings.hostname}" ];

		nix = {
			optimise.automatic = false;
			gc = {
				automatic = false;
				dates = "17:30";
				options = "--delete-older-than 15d";
			};

			settings =
			{
				allowed-users = [ "${settings.username}" ];
				experimental-features = [ "nix-command" "flakes" ];

				auto-optimise-store = true;
				warn-dirty = false;

				trusted-public-keys =
				[
					"msi.host.local:jbqDHg/Ky3EjKvI0Wtf2LZyiuxcbuJarlxA26WAAeT4="
				];
			};

			extraOptions = ''
# Options can be found at <https://nix.dev/manual/nix/2.24/command-ref/conf-file>
connect-timeout = 2                # The timeout (in seconds) for establishing connections in the binary cache substituter
download-buffer-size = 1073741824  # The size of Nix's internal download buffer (Bytes) (1 GiB)
fallback = true                    # Nix will fall back to building from source if a binary substitute fails
narinfo-cache-positive-ttl = 0     # If a store path is queried from a substituter, the result of the query will be cached in the local disk cache database including some of the NAR metadata
narinfo-cache-negative-ttl = 0     # If a store path is queried from a substituter but was not found, there will be a negative lookup cached in the local disk cache database for the specified duration
'';
		};

		services.journald.extraConfig = "SystemMaxUse=1G";

		nixpkgs.config = let pkgs = settings.special_pkgs; in {
			permittedInsecurePackages = pkgs.insecure;
			allowUnfreePredicate = pkg: builtins.elem
				(lib.getName pkg) pkgs.unfree;
		};
	};
}
