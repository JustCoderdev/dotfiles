{ config, lib, ... }:

let
	cfg = config.common.manifest;
	hostname = config.networking.hostName;
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
		networks = mkSubmodOption "The map of all available networks"
		(
			{ name, config, ... }:
			{
				options = (import ./networks/options.nix { inherit name lib config; });
			}
		);

		hosts = mkSubmodOption "The set with the manifest for registered hosts"
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

					users = lib.mkOption {
						description = "User preferences";
						type = lib.types.listOf lib.types.str;
						default = [ "ryuji" ];
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
