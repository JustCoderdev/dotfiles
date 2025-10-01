{ pkgs, ... }:

{
	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	networking.hosts = {
		"192.168.1.5"   = [  "msi.host.lan" ];
		"192.168.1.8"   = [ "asus.host.lan" ];
	};

	# WIREGUARD CLIENT

	system.services.wireguard = {
		openFirewall = true;
		client =
		{
			enable = true;
			servers.wg-msi = {
				endpoint = "msi.foxburrow.org:51820";
				publicKey = "FHDRB/hzK85kTPMDJH6IZTRakcy3tl8Qy9vLG7/JujQ=";

				self-ip = "10.255.250.4/24";
				allowed-ips = [
					"10.255.250.1/32" # msi
					"10.255.250.2/32" # quiss
					"10.255.250.3/32" # iphone-tp-2_0
				];
			};
		};
	};

}
