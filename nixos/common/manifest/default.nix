{ config, lib, jc-lib, settings, ... }:

let
	inherit (settings) hostname;

	cfg = config.common.manifest;
in

{
	imports =
	[
		./software/list-options.nix

		./software/default.nix
		./networks/default.nix
	];

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


		hosts = jc-lib.mkSubmodOption "The set with the manifest for registered hosts"
		(
			{ name, ... }:
			{
				imports =
				[
					./hardware-options.nix
					./software-options.nix
				];

				options =
				{
					hostname = lib.mkOption {
						description = "The name of the host of this manifest";
						default = name;
						type = lib.types.str;
						readOnly = true;
					};
				};
			}
		);

		self = lib.mkOption {
			description = "The manifest for this host";
			type = lib.types.attrs; # type = lib.types.submodule host-options;
			default = cfg.hosts.${hostname};
			readOnly = true;
		};
	};
}
