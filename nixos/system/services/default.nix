{ lib, ... }:

{
	imports = [
		./docker.nix
		./nixcache.nix
		./samba.nix
		./virtualbox.nix
		./webserver.nix
	];

	options = {
		system.services = {
			docker.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable docker daemon";
				default = false;
			};
			nixcache = {
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
					default = "nixcache.local";
				};
				instance-port = lib.mkOption {
					type = lib.types.port;
					description = "Local nixcache port";
					default = 56552;
				};
			};
			samba.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable samba daemon";
				default = false;
			};
			virtualbox.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable virtualbox daemon";
				default = false;
			};
			webserver.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable webserver and serve files at /var/www/HOSTNAME";
				default = false;
			};
		};
	};
}
