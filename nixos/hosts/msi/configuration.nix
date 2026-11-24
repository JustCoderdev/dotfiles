{ lib, pkgs, nix-minecraft, ... }:


{
	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ] ++ [ dbeaver-bin kicad gsmartcontrol ];


	# Temporary services
	# ------------------------------------------------------------ #

	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

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

	# MINECRAFT SERVERS

	# imports = [ nix-minecraft.nixosModules.minecraft-servers ];
	# nixpkgs.overlays = [ nix-minecraft.overlay ];
	#
	# services.minecraft-servers =
	# {
	# 	enable = true;
	# 	openFirewall = true;
	# 	eula = true;
	#
	# 	servers =
	# 	let
	# 	# <https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3>
	# 		default-properties =
	# 		{
	# 			allow-flight = true;
	# 			force-gamemode = false;
	# 			player-idle-timeout = 0;
	# 			spawn-protection = 0;
	#
	# 			snooper-enabled = false;
	# 			online-mode = false;
	# 			use-native-transport = true;
	# 			verify-names = false;
	#
	# 			white-list = false;
	# 			enforce-whitelist = false;
	# 		};
	#
	# 		# <https://mcuuid.net/> <https://namemc.com>
	# 		ryuji-uuid = "e2458645-fb10-4065-ac0c-f689aa30adff";
	# 		default-operators = { Ryuji_terix = ryuji-uuid; };
	# 	in
	# 	{
	# 		vanilla-plus =
	# 		{
	# 			enable = true;
	# 			package = pkgs.vanillaServers.vanilla-1_12_2;
	# 			openFirewall = true;
	#
	# 			autoStart = true;
	# 			jvmOpts = "-Xms4092M -Xmx6144M";
	#
	# 			operators = default-operators // { };
	#
	# 			serverProperties = default-properties
	# 			// {
	# 				server-port = 25565;
	# 				motd = "Be croime do goys";
	#
	# 				level-name = "world";
	# 				difficulty = 2; # peaceful, easy, normal, hard
	# 				gamemode = 0; # survival, creative, adventure, spectator
	#
	# 				view-distance = 20;
	# 				max-players = 10;
	# 			};
	# 		};
	# 	};
	# };
}
