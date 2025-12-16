{ config, lib, settings, ... }:

let
	inherit (settings) username;
	cfg = config.system.services.syncthing;
in

{
	config =
	{
		services.syncthing = lib.mkIf (cfg.enable)
		{
			enable = true;
			openDefaultPorts = cfg.openFirewall;

			inherit (cfg) group dataDir;
			user = cfg.username;

			overrideDevices = true;
			overrideFolders = true;

			settings =
			{
				devices =
				(
					lib.attrsets.mapAttrs
					(
						name: value:
						{
							inherit (value) id;
							addresses = [ "dynamic" ]
							++ (lib.lists.optional (value.address != null) value.address)
							;
						}
					)
					(cfg.devices)
				);

				folders = (
					builtins.listToAttrs (
						builtins.map (
							name:
							{
								inherit name;
								value =
								{
									enable = true;
									path = "${cfg.dataDir}/${name}";
									devices = lib.attrsets.mapAttrsToList (
										name: value: name
									) cfg.devices;

									versioning = {
										type = "staggered";
										params.maxAge = "30";
									};
								};
							}
						) cfg.folders
					)
				);

				options = {
					relaysEnabled = false;
					urAccepted = -1;
				};

				gui =
				let
					ryuji-bcrypt-hash = "$2a$12$0kowJfxX5HrcWqzdGYZYO.DovHvrBWYxjSb1/EyZOOd/c.AMVPkri";
				in
				{
					enabled = true;
					tls = false; # require https
					value = {
						address = "127.0.0.1:8384"; # :8384
						user = "ryuji";
						password = ryuji-bcrypt-hash; # bcrypt hash
						insecureAdminAccess = false; # allow access to GUI from non localhost
					};
				};
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.syncthing =
	let
		mkSubmodOption = (
			description: submodule:
			lib.mkOption {
				inherit description;
				type = lib.types.attrsOf (lib.types.submodule (submodule));
				default = { };
			}
		);
	in
	{
		enable = lib.mkEnableOption "syncthing daemon";
		openFirewall = lib.mkEnableOption "Open firewall";
		dataDir = lib.mkOption {
			description = "The path where synchronised directories will exist";
			type = lib.types.path;
			default = "/home/${cfg.username}/Documents/synced";
		};

		username = lib.mkOption {
			description = "User to run syncthing as";
			type = lib.types.str;
			default = username;
		};
		group = lib.mkOption {
			description = "Group to run syncthing as";
			type = lib.types.str;
			default = config.users.users."${cfg.username}".group;
		};

		folders = lib.mkOption {
			description = "List of all folders on the 'network'";
			type = lib.types.listOf lib.types.str;
			default = [];
		};

		devices = mkSubmodOption "Attribute set of all devices in the same 'network'" (
			name:
			{
				options = {
					id = lib.mkOption {
						description = "The id of the device";
						type = lib.types.nullOr lib.types.str;
						default = null;
					};

					address = lib.mkOption {
						description = "Address or hostname to connect to this device";
						type = lib.types.nullOr lib.types.str;
						default = null;
					};
				};
			}
		);
	};
}

