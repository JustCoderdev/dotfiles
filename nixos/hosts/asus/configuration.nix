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
}
