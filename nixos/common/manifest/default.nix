{ config, lib, jc-lib, settings, ... }:

let
	cfg = config.common.manifest;
in

{
	imports = [
		./hardware/default.nix
		./software/default.nix
		./networks/default.nix
	];

	config = { };

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
