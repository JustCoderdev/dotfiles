{ config, lib, pkgs, nix-minecraft, pkgs-unstable, ... }:

let
	secrets = config.common.core.secrets;
in

{
	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ] ++ [ dbeaver-bin ];

	programs.nix-ld =
	{
		enable = true;
		libraries = [ pkgs.stdenv.cc.cc.lib ];
	};

	# TUNNEL

	unofficial.services.cloudflared =
	{
		enable = true;
		certificateFile = secrets.cloudflare.origin-cert.path;

		tunnels."msi-cf" =
		{
			credentialsFile = secrets.cloudflare.tunnel-creds."msi-cf".path;
			default = "http_status:404";
			originRequest.noTLSVerify = true;
			ingress."msi-cf.foxburrow.org".service = "ssh://127.0.0.1:22";
		};
	};

	# services.sunshine =
	# {
	# 	enable = true;
	# 	openFirewall = true;
	# 	capSysAdmin = true;
	# };


	# Temporary services
	# ------------------------------------------------------------ #

	# services.mysql = {
	# 	enable = true;
	# 	package = pkgs.mariadb;
	# };

	# MINECRAFT SERVERS

	imports = [ nix-minecraft.nixosModules.minecraft-servers ];
	nixpkgs.overlays = [ nix-minecraft.overlay ];

	services.minecraft-servers =
	{
		enable = false;
		openFirewall = true;
		eula = true;

		# dataDir = "/home/WDC_WD10/minecraft-servers";

		servers =
		let
			# <https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3>
			default-properties =
			{
				allow-flight = true;
				force-gamemode = false;
				player-idle-timeout = 0;

				snooper-enabled = false;
				online-mode = false;
				use-native-transport = true;
				verify-names = false;

				white-list = false;
				enforce-whitelist = false;
			};

			# <https://mcuuid.net/> <https://namemc.com>
			ryuji-uuid = "e2458645-fb10-4065-ac0c-f689aa30adff";
			default-whitelist = { Ryuji_terix = ryuji-uuid; };
			default-operators = { Ryuji_terix = ryuji-uuid; };
		in
		{
			CnT-1_21_11 =
			{
				enable = false;
				package = pkgs.vanillaServers.vanilla-1_21_11;

				openFirewall = true;

				autoStart = false;
				jvmOpts = "-Xms4092M -Xmx6144M";

				operators = default-operators // { };
				whitelist = default-whitelist // { };

				serverProperties = default-properties
				// {
					server-port = 25565;
					motd = "Vanilla w the boyz";

					level-name = "world";
					difficulty = 3; # peaceful, easy, normal, hard
					gamemode = 0; # survival, creative, adventure, spectator

					view-distance = 20;
					max-players = 5;
				};

				symlinks."server-icon.png" = ./server-icon.png;
			};

			parkour-pyramid =
			let
				world-files = pkgs.fetchzip
				{
					url = "https://hielkemaps.com/downloads/Parkour%20Pyramid.zip";
					hash = "sha256-hPFTv2H7TJ9FWny2tUOsT2f6k+NfMeCLTyOmefiZK6I=";
				};
			in
			{
				enable = false;
				package = pkgs.vanillaServers.vanilla-1_21_11;

				openFirewall = true;

				autoStart = false;
				jvmOpts = "-Xms4092M -Xmx6144M";

				operators = default-operators // { };
				whitelist = default-whitelist // { };

				serverProperties = default-properties
				// {
					server-port = 25565;
					motd = "Parkour piramid mentre Cri che fà programmazione";

					level-name = "world";
					difficulty = 3; # peaceful, easy, normal, hard
					gamemode = 0; # survival, creative, adventure, spectator

					view-distance = 20;
					max-players = 5;
				};

				symlinks."server-icon.png" = world-files + ./icon.png;
				files =
				(
					lib.attrsets.mapAttrs'
						(name: lib.attrsets.nameValuePair "world/${name}")
						(nix-minecraft.lib.collectFiles world-files)
				);
			};
		};
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
}
