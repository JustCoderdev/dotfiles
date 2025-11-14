{ config, lib, jc-lib, ... }:

{
	options.common.manifest.services =
	{
		wireguard = jc-lib.mkSubmodOption "Wireguard service manifest"
		(
			{ name, ... }:
			{
				options = 
				let
					wg-default-port = 51820;
				in
				{
					enable = lib.mkEnableOption "this wireguard server interface";

					server-hostname = jc-lib.mkStrOption "The hosts that is running this service";
					endpoint =
					{
						url = jc-lib.mkStrOption "The hostname or ip of the server (wireguard.example.com:51820)";
						port = lib.mkOption {
							type = lib.types.port;
							description = "port of the interface";
							default = wg-default-port;
						};
					};

					network =
					{
						id = jc-lib.mkStrOption "The IP address of the network tunnel";
						mask = jc-lib.mkIntOption "The netmask of the network tunnel";
					};

					extraPeers = jc-lib.mkSubmodOption "Extra peers to add that are not declared in other manifests"
					(
						{ name, ... }:
						{
							options = {
								address = jc-lib.mkStrOption "The ip address of the peer (127.0.0.1)";
								publicKey = jc-lib.mkStrOption "The public key of the peer";
							};
						}
					);
				};
			}
		);
	};
}

