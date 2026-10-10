{ pkgs, ... }:


{
	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ] ++ [ dbeaver-bin kicad gsmartcontrol ];


	# Temporary services
	# ------------------------------------------------------------ #

	# services.mysql = {
	# 	enable = true;
	# 	package = pkgs.mariadb;
	# 	# settings.mysqld.innodb_buffer_pool_size = "1GB";
	# };

	# services.deluge =
	# {
	# 	enable = true;
	# 	openFirewall = true;
	# 	group = "users";
	#
	# 	declarative = true;
	# 	authFile = "/var/lib/deluge/auth";
	# 	config = {
	# 		"new_release_check" = false;
	#
	# 		"enabled_plugins" = [ "Label" "Stats" ];
	#
	# 		"max_active_seeding" = 0;
	# 		"max_active_downloading" = 20;
	# 		"max_active_limit" = 30;
	# 		"max_connections_global" = 100;
	# 	};
	#
	# 	web = {
	# 		enable = true;
	# 		port = 8112;
	#
	# 		# hack until baseurl bug gets fixed
	# 		openFirewall = true;
	# 		# inherit (cfg) openFirewall;
	# 	};
	# };
}
