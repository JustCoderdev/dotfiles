{ ... }:

{
	networking.firewall = {
		enable = true;
		allowPing = true;

		# Open ports in the firewall.
		# interfaces.<name>.
		allowedTCPPorts = [
#			25565 # Minecraft
#			5222  # Satisfactory
#			6666  # Satisfactory
		];
		allowedUDPPorts = [
#			25565 # Minecraft
#			5222  # Satisfactory
#			6666  # Satisfactory
		];
		allowedUDPPortRanges = [
#			{ from = 7777; to = 7827; } # Satisfactory
		];
	};
}
