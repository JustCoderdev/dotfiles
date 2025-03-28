{ lib, ... }:

{
	imports = [
		./docker.nix
		./nixbuilder.nix
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
			nixbuilder = {
				server = {
					enable = lib.mkOption {
						type = lib.types.bool;
						description = "Configure this device as a nixbuilder";
						default = false;
					};
					systems = lib.mkOption {
						type = lib.types.listOf lib.types.str;
						description = "The systems supported by the builder";
					};
				};
				client.builders = lib.mkOption {
					type = lib.types.listOf (
						lib.types.submodule (
							{ config, ... }:
							{
								hostName = lib.mkOption {
									type = lib.types.str;
									description = "How to reach the builder";
								};
								maxJobs = lib.mkOption {
									type = lib.types.int;
									description = "The number of concurrent jobs the builder supports";
									default = 1;
								};
								priority = lib.mkOption {
									type = lib.types.int;
									description = "The computational priority of this builder";
									default = 1;
								};
								features = lib.mkOption {
									type = lib.types.listOf lib.types.str;
									description = "The features of the builder";
								};
								systems = lib.mkOption {
									type = lib.types.listOf lib.types.str;
									description = "The systems supported by the builder";
								};
							}
						)
					);
					description = "Known builders that the client can offload the work to";
					default = [];
				};
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
					default = null;
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
