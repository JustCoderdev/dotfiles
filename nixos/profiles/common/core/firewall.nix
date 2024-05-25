{ ... }:

{
	networking.firewall = {
		enable = true;

		# Open ports in the firewall.
		# interfaces.<name>.
		# 	allowedTCPPorts = [ ... ];
		# 	allowedUDPPorts = [ ... ];
	};
}
