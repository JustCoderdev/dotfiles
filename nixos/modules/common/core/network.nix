{ settings, ... }:

{
	# Network settings
	networking = {
		hostName = settings.hostname;
		networkmanager.enable = true;

		# Enable wireless support via wpa_supplicant.
		wireless = {
			enable = false;
			networks = {
				# "WindTower" = {
				# 	psk = "******";
				#	psk = "@KEY@"; #read `environmentFile`
				# };

				# Public wifi networks
				"free.wifi" = {};
			};
		};

		# DNS Servers
		nameservers = [
			"193.110.81.0" # https://www.dns0.eu/it
			"185.253.5.0"  # https://www.dns0.eu/it
		];

		# DNS Records
		hosts = {
			"192.168.7.1" = [ "gateway.local" ];
			"192.168.7.142" = [ "nixcache.local" "msi.host.local"];
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
	};
}
