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
		ssh.pubkey = lib.mkOption
		{
			description = "ssh public keys installed on the device";
			default = { };
			type = lib.types.attrsOf lib.types.str;
		};

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

		syncthing =
		{
			enable = lib.mkEnableOption "syncthing for this host";

			identification = mkStrOption "The identification string of this peer";
			data-dir = lib.mkOption {
				description = "absolute path to the data directory";
				type = lib.types.nullOr lib.types.str;
				default = null;
			};
		};
	};
}
