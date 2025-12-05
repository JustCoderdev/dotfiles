{ lib, ... }:

let
	mkStrOption = (
		description:
		lib.mkOption {
			inherit description;
			type = lib.types.str;
		}
	);
in

{
	options.software =
	{
		wireguard = lib.mkOption {
			description = "Wireguard service manifest";
			default = { };
			type = lib.types.attrsOf
			(
				lib.types.submodule
				(
					{ ... }:
					{
						options =
						{
							enable = lib.mkEnableOption "wireguard for this host";

							# TODO: Check that string is a valid cidr
							self-address = mkStrOption "The ip address of this peer";
							publicKey = mkStrOption "The public key of the peer";
						};
					}
				)
			);
		};
	};
}
