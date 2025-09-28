{ config, pkgs, ... }:

{
	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ]
	++ [ ciscoPacketTracer8 dbeaver-bin ]; # more packages support

	networking.hosts = {
		"192.168.1.5"   = [  "msi.host.lan" ];
		"192.168.1.8"   = [ "asus.host.lan" ];
	};

	# DDNS

	services.cloudflare-dyndns =
	{
		enable = true;
		apiTokenFile = config.common.core.secrets.cloudflare.api-token.path;
		domains = [
			"msi.foxburrow.org"
		];
	};

	# Wireguard

	system.services.wireguard = {
		openFirewall = true;
		server =
		{
			enable = true;

			tunnel-network = "10.255.250.0/24";
			self-ip = "10.255.250.1/24";

			external-interface = "wlp3s0";
			internal-interface = "wg-server";

			peers =
			let
				add-peer = (
					publicKey: ip:
					{ inherit publicKey ip; }
				);
			in
			{
				        quiss = (add-peer "UQYuZhhWWm2kYNXeoIxb+50Dv/XYb9bQDFc8DTSFbT0=" "10.255.250.2");
				iphone-tp-2_0 = (add-peer "WUEqbbv7RGfw9EhKjPDeZqwkuKwsODsdTtvMv7Gt+Vk=" "10.255.250.3");
			};
		};
	};

	# Nginx quiss proxy

	# Port 80 opened for acme
	networking.firewall.allowedTCPPorts = [ 443 80 ];
	services.nginx =
	{
		enable = true;
		virtualHosts."msi.foxburrow.org" =
		{
			locations."/".proxyPass = "https://10.255.250.2";

			# addSSL = true;
			forceSSL = true;
			enableACME = true;
		};
	};

	security.acme = {
		acceptTerms = true;
		defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
	};
}
