{ ... }:

{
	# Network settings
	networking = {

		# Enable networking
		networkmanager.enable = true;

		# Enable wireless support via wpa_supplicant.
		wireless = {
			enable = false;

			# Force a specific driver
			# driver = "";

			networks = {
				# "WindTower" = {
				# 	psk = "******";
				#	psk = "@KEY@"; #read `environmentFile`
				# };

				# Public wifi networks
				"free.wifi" = {};
			};
		};

		# Configure proxy
		# proxy = {
		#	 proxy.default = "http://user:password@proxy:port/";
		#	 proxy.noProxy = "127.0.0.1,localhost,internal.domain";
		# };

		# Set network default Gateway
		# defaultGateway = {
		#	 address = "192.168.1.1";
		#	 interface = "eth0";
		# }

		# Manually set an address to interfaces
		# interfaces = {
		#	eth0.ipv4.addresses = [
		# 		{
		# 			address = "192.168.1.69";
		# 		};
		# 	];
		# };

		# Set local dns records
		# hosts = {
		# 	"127.0.0.1" = [ "WindTower.me" ];
		# };
	};
}
