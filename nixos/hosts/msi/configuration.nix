{ config, pkgs, nix-minecraft, ... }:

let
	secrets = config.common.core.secrets;
in

{
	imports = [ nix-minecraft.nixosModules.minecraft-servers ];
	nixpkgs.overlays = [ nix-minecraft.overlay ];

	networking.firewall.allowedTCPPorts = [ 3000 ] ++ [ 7000 7100 ];
	networking.firewall.allowedUDPPorts = [ 6000 6001 7011 ];

	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ]
	++ [ dbeaver-bin uxplay ]; # more packages support

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

	# MINECRAFT SERVERS

	services.minecraft-servers =
	{
		enable = true;
		openFirewall = true;
		eula = true;

		# dataDir = "/home/WDC_WD10/minecraft-servers";

		servers =
		let
			# <https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3>
			default-properties = {
				allow-flight = true;
				difficulty = 3; # peaceful, easy, normal, hard
				enforce-whitelist = false;
				force-gamemode = false;
				gamemode = 0; # survival, creative, adventure, spectator
				online-mode = true;
				player-idle-timeout = 0;
				snooper-enabled = false;
				use-native-transport = true;
				view-distance = 20;
			};

			# <https://mcuuid.net/> <https://namemc.com>
			default-whitelist = {
				ryuji_terix = "e2458645-fb10-4065-ac0c-f689aa30adff";
			};
		in
		{
			CnT-1_21_11 =
			{
				enable = true;
				package = pkgs.vanillaServers.vanilla-1_21_11;

				openFirewall = true;

				autoStart = false;
				jvmOpts = "-Xms4092M -Xmx6144M";

				serverProperties = default-properties // {
					level-name = "world";
					max-players = 5;
					motd = "Test vanilla 1.21.1";
					server-port = 25565;
					white-list = false;
				};
				whitelist = default-whitelist // { };
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
