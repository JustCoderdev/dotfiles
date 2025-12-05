{ lib, ... }:

let
	mkSubmodOption = (
		description: submodule:
		lib.mkOption {
			inherit description;
			type = lib.types.attrsOf (lib.types.submodule (submodule));
			default = { };
		}
	);

	mkStrOption = (
		description:
		lib.mkOption {
			inherit description;
			type = lib.types.str;
		}
	);
in

{
	options.common.manifest.services =
	{
		wireguard = mkSubmodOption "Wireguard service manifest"
		(
			{ name, ... }:
			{
				options =
				let
					wg-default-port = 51820;
				in
				{
					enable = lib.mkEnableOption "this wireguard server interface";

					server-hostname = mkStrOption "The hosts that is running this service";
					endpoint =
					{
						url = mkStrOption "The hostname or ip of the server (wireguard.example.com:51820)";
						port = lib.mkOption {
							type = lib.types.port;
							description = "port of the interface";
							default = wg-default-port;
						};
					};

					# TODO: Add checks
					network =
					{
						id = mkStrOption "The IP address of the network tunnel";
						mask = lib.mkOption {
							description = "The netmask of the network tunnel";
							type = lib.types.int;
						};
					};

					extraPeers = mkSubmodOption "Extra peers to add that are not declared in other manifests"
					(
						{ name, ... }:
						{
							options = {
								address = mkStrOption "The ip address of the peer (127.0.0.1)";
								publicKey = mkStrOption "The public key of the peer";
							};
						}
					);
				};
			}
		);
	};
}

