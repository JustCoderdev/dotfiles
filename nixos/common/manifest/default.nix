{ config, lib, jc-lib, settings, ... }:

let
	cfg = config.common.manifest;
	boot-cfg = config.boot;
	self-manifest = cfg.self;

	hosts-dir = "${settings.dotfiles_store_path}/nixos/hosts";
	hosts-name = (
		lib.attrsets.mapAttrsToList (name: _: name) (
			lib.attrsets.filterAttrs
			(
				name: value:
				!(lib.strings.hasPrefix "." name) && (value == "directory")
			)
			(builtins.readDir hosts-dir)
		)
	);
in

{
	imports = [
		./hardware/default.nix
		# ./software/default.nix
		# ./network/default.nix
	];

	config =
	{
		# All manifests
		# -------------------- #

		common.manifest.hosts = (
			builtins.listToAttrs (
				builtins.map (
					host-name:
					{
						name = host-name;
						value = import "${hosts-dir}/${host-name}/manifest.nix";
					}
				) (hosts-name)
			)
		);


		# Put network hosts in manifest
		# -------------------- #
		common.manifest.networks = import ./networks-list.nix;

		# common.manifest.networks = (
		# 	builtins.listToAttrs (
		# 		builtins.map (
		# 			network:
		# 			{
		# 				name = network.name;
		# 				value =
		# 				{
		# 					# hosts = ();
		# 				};
		# 			}
		# 		) (common.manifest.networks)
		# 	)
		# );
	};

	# ------------------------------------------------------------ #

	options.common.manifest =
	{
		networks = jc-lib.mkSubmodOption "The map of all available networks"
		(
			{ name, lib, ... }:
			{
				options =
				{
					name = jc-lib.mkStrOptionRO "The name of the network" name;

					# netid = jc-lib.mkStrRXOption "The id of the network" jc-lib.regex.address.ipv4;
					netid = jc-lib.mkStrOption "The id of the network";
					netmask = jc-lib.mkIntOption "The mask of the network";

					domain-lan = lib.mkOption {
						description = "The subdomain name of the network (<hostname>.<domain>.lan)";
						type = lib.types.str;
						default = name;
					};

					hosts = jc-lib.mkSubmodOption "The hosts in this network"
					(
						{ name, ... }:
						{
							config =
							{
								# TODO: should assert that `name` is a valid ip in range of the network id w mask
								# assertions = [ {
								# 	assertion = (builtins.match jc-lib.regex.address.ipv4 name) != null;
								# 	message = "The ip of the host is not an ip ('${name}')";
								# } ];
							};

							options =
							{
								hostname = jc-lib.mkStrOption "The hostname of the device with this ip in this network";
							};
						}
					);
				};
			}
		);

		hosts = jc-lib.mkSubmodOption "The manifest for all known nixos devices"
		(
			{ name, config, ... }:
			{
				options =
				{
					hostname = jc-lib.mkStrOptionRO "The hostname of this manifest" name;
					hardware = (import ./hardware/options.nix { inherit name lib config jc-lib; });
					# software = (import ./software/options.nix { inherit name config; });
				};
			}
		);

		self = lib.mkOption {
			description = "The manifest for all known nixos devices";
			type = lib.types.attrs; # type = lib.types.submodule host-options;
			default = cfg.hosts.${settings.hostname};
			readOnly = true;
		};
	};
}
