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
		./software/default.nix
		./networks/default.nix
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
	};

	# ------------------------------------------------------------ #

	options.common.manifest =
	{
		networks = jc-lib.mkSubmodOption "The map of all available networks"
		(
			{ name, config, ... }:
			{
				options = (import ./networks/options.nix { inherit name lib config jc-lib; });
			}
		);

		services = (import ./software/list-options.nix { inherit lib config jc-lib; });

		hosts = jc-lib.mkSubmodOption "The manifest for all known nixos devices"
		(
			{ name, config, ... }:
			{
				options =
				{
					hostname = jc-lib.mkStrOptionRO "The hostname of this manifest" name;
					hardware = (import ./hardware/options.nix { inherit name lib config jc-lib; });
					software = (import ./software/manifest-options.nix { inherit name lib config jc-lib; });
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
