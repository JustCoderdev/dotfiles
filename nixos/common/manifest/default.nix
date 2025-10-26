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
	};

	# ------------------------------------------------------------ #

	options.common.manifest =
	{
		# networks = (import ./network/options.nix { inherit name config; });
		# networks = jc-lib.mkSubmodOption "The map of all available networks" (networks-options);

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
