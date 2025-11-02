{ name, config, lib, jc-lib }:

{
	wireguard = jc-lib.mkSubmodOption "Wireguard service manifest"
	(
		{ name, ... }:
		{
			options = 
			{
				enable = lib.mkEnableOption "Wheater to enable wireguard for this host";
				is-server = lib.mkEnableOption "Wheather this is the server for the interface";

				# TODO: Check that string is a valid cidr
				self-address = jc-lib.mkStrOption "The ip address of this peer";
				publicKey = jc-lib.mkStrOption "The public key of the peer";
			};
		}
	);
}
