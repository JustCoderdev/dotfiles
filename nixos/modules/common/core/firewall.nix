{ ... }:

{
	networking.firewall = {
		enable = true;
		allowPing = true;

		# Open ports in the firewall.
		# interfaces.<name>.
		allowedTCPPorts = [ 25565 ];
		allowedUDPPorts = [ 25565 ];
	};
}
