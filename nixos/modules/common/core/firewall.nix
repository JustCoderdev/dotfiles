{ ... }:

{
	networking.firewall = {
		enable = true;
		allowPing = true;

		# Open ports in the firewall.
		# interfaces.<name>.
		# 	allowedTCPPorts = [ ... ];
		# 	allowedUDPPorts = [ ... ];
	};
}
