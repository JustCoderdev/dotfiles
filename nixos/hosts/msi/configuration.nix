{ config, pkgs, settings, ... }:

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

	# Remote desktop / graphical tablet

	programs.weylus =
	{
		enable = true;
		openFirewall = true;
		users = [ settings.username ];
	};
}
