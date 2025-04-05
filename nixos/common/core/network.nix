{ settings, ... }:

{
	# Fix hangups
	systemd.network.wait-online.enable = false;
	boot.initrd.systemd.network.wait-online.enable = false;

	# Network settings
	networking = {
		hostName = settings.hostname;
		domain = "host.local";

		networkmanager.enable = true;
		wireless.enable = false; # disable wpa_supplicant.
		# dhcpcd.enable = false;

		# DNS Servers
		nameservers = [
			"193.110.81.0" # https://www.dns0.eu/it
			"185.253.5.0"  # https://www.dns0.eu/it
		];

		# Local DNS Records
		hosts = {
			"192.168.7.1"   = [                "gateway.local" ];
			"192.168.7.16"  = [              "acer.host.local" ];
			"192.168.7.142" = [               "msi.host.local" ];
			# "192.168.7.168" = [             "quiss.host.local" ];
			# "192.168.7.222" = [            "jarvis.host.local" ];

			"192.168.7.230" = [            "home-assistant.service.local" ];
		};
	};
}
