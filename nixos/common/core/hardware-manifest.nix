{ config, lib, ... }:

let
	cfg = config.common.core.hardware-manifest;

in

{
	config = { };

	# ------------------------------------------------------------ #

	options.common.core.hardware-manifest = lib.mkOption {
		description = "A manifest to all hardware capability";
		type = lib.types.attrsOf (
			lib.types.submodule (
				{ name, ... }:
				{
					options = 
					{
# services
#	nix builder
#	nix cache

# network
#	networks
#	interfaces
#		mac address
#		ip addresses
#		wol enabled


					};
				}
			)
		);
	};
}
