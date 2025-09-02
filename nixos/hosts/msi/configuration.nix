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

	# networking.interfaces."wlp3s0".ipv4.routes = [
	# 	{
	# 		address = "10.255.255.248";
	# 		prefixLength = 30;
	# 		via = "192.168.7.1";
	# 		type = "unicast";
	# 	}
	# ];

	# DDNS

	services.cloudflare-dyndns =
	{
		enable = true;
		apiTokenFile = config.common.core.secrets.cloudflare.api-token.path;
		domains = [ "msi.foxburrow.org" ];
	};
}
