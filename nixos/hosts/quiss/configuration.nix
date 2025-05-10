{ config, pkgs-unstable, pkgs, settings, inputs, ... }:

let
	inherit (settings) dotfiles_path username;
	unstable-path = inputs.nixpkgs-unstable.outPath;
	secrets = config.common.core.secrets;

	cfdomain = "foxburrow.org";

	raid-mount = "/mnt/md0";
	config-dir = raid-mount + "/.config";
	data-dir   = raid-mount + "/data";
	downloads-dir = data-dir + "/downloads";
	game-dir      = data-dir + "/game";

	openFirewall = false;
	serv-group = "maid";
	proxy = {
		enable = true;
		host = "quiss.server.local";
	};
in

{
	disabledModules = [ "services/networking/cloudflared.nix" ];
	imports = [ ../../unofficial/cloudflared.nix ];

	# nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
	# inputs.nix-minecraft.nixosModules.minecraft-servers

	# ------------------------------------------------------------ #

	# Create service group
	users.groups."${serv-group}" = { };
	users.users.${username}.extraGroups = [ serv-group ];

	systemd.tmpfiles.rules = [
#		Type Path                    Mode User Group
		"d   ${config-dir}           0775 root ${serv-group}"
		"d   ${data-dir}             0775 root ${serv-group}"

		"d   ${game-dir}             0775 root ${serv-group}"
		"d   ${downloads-dir}        0775 root ${serv-group}"
		"d   ${data-dir}/documents   0775 root ${serv-group}"

		"d   ${data-dir}/media/movie 0775 root ${serv-group}"
		"d   ${data-dir}/media/serie 0775 root ${serv-group}"
		"d   ${data-dir}/music       0775 root ${serv-group}"
		"d   ${data-dir}/books       0775 root ${serv-group}"
	];

	# ------------------------------------------------------------ #

	# TUNNEL

	# Configure DNS on cloudflare interface
	# <https://blog.cloudflare.com/argo-tunnels-that-live-forever/>
	# <https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/routing-to-tunnel/dns/>
	unofficial.services.cloudflared =
	{
		enable = true;
		certificateFile = secrets.cloudflare.origin-cert.path;

		tunnels."home" =
		{
			credentialsFile = secrets.cloudflare.tunnel-creds."home".path;
			default = "http_status:404";

			originRequest.noTLSVerify = true;

			ingress = 
			{
				 "ssh.foxburrow.org".service = "ssh://127.0.0.1:22";

				"home.foxburrow.org".service = "https://127.0.0.1:443";

				"jellyfin.foxburrow.org".service = "http://127.0.0.1:8096";
				  "immich.foxburrow.org".service = "http://127.0.0.1:2283";

				  "deluge.foxburrow.org".service = "http://127.0.0.1:8112";
				"prowlarr.foxburrow.org".service = "http://127.0.0.1:9696";
				  "bazarr.foxburrow.org".service = "http://127.0.0.1:6767";

				 "lidarr.foxburrow.org".service = "http://127.0.0.1:8686";
				 "radarr.foxburrow.org".service = "http://127.0.0.1:7878";
				"readarr.foxburrow.org".service = "http://127.0.0.1:8787";
				 "sonarr.foxburrow.org".service = "http://127.0.0.1:8989";
			};
		};
	};

	# ------------------------------------------------------------ #

	# SAMBA

	system.services.samba.shares.custom = let
		create-share = (name: root: owner: { inherit name root owner; });
	in [
		(create-share "data" raid-mount settings.username)
	];

	# Homepage
	# <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>

	networking.firewall.allowedTCPPorts = [ 443 80 ];
	services.nginx =
	{
		enable = true;
		virtualHosts."${proxy.host}" = let 
			vhost-secrets = secrets.nginx.vhosts."${proxy.host}";
		in {
			locations = {
				"= /home".return = "301 http://192.168.7.7/home/index.html";
				"^~ /home/" = {
					root = data-dir + "/homepage";
					index = "index.html";
				};
			};

			# forceSSL = true;
			addSSL = true;
			sslCertificate = vhost-secrets.cert.path;
			sslCertificateKey = vhost-secrets.key.path;
		};
	};

	# ARR Stack

	system.services.servarr =
	{
		inherit openFirewall proxy;
		enable = true;

		group = serv-group;

		config-root-dir = config-dir;
		shared-downloads-dir = downloads-dir;

		apps = {
			prowlarr.enable = true;
			deluge.enable = true;
			bazarr.enable = true;

			lidarr.enable = true;
			radarr.enable = true;
			readarr.enable = true;
			sonarr.enable = true;
		};
	};

	# MEDIA PLAYER

	system.services.jellyfin =
	{
		inherit openFirewall proxy;
		enable = true;

		config-dir = config-dir + "/jellyfin";
		group = serv-group;
	};

	# Gallery Backup

	system.services.immich =
	{
		inherit openFirewall proxy;
		enable = true;

		config-dir = config-dir + "/immich";
		group = serv-group;
	};

	# MINECRAFT SERVERS

	# services.minecraft-servers = {
	# 	enable = false;
	# 	eula = true;

	# 	dataDir = "${game-dir}/minecraft/";

	# 	servers =
	# 	let
	# 		# <https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3>
	# 		default-properties = {
	# 			allow-flight = true;
	# 			difficulty = 3; # peaceful, easy, normal, hard
	# 			enforce-whitelist = false;
	# 			force-gamemode = false;
	# 			gamemode = 0; # survival, creative, adventure, spectator
	# 			online-mode = true;
	# 			player-idle-timeout = 0;
	# 			snooper-enabled = false;
	# 		};

	# 			# <https://mcuuid.net/> <https://namemc.com>
	# 		default-whitelist = {
	# 			ryuji_terix = "e2458645-fb10-4065-ac0c-f689aa30adff";
	# 		};
	# 	in
	# 	{
	# 		test-1-12 = {
	# 			enable = true;
	# 			package = pkgs.vanillaServers.vanilla-1_12_2;
	# 			inherit openFirewall;

	# 			jvmOpts = "-Xms4092M -Xmx6144M";

	# 			serverProperties = default-properties // {
	# 				level-name = "world";
	# 				max-players = 5;
	# 				motd = "Test vanilla 1.12.2";

	# 				server-port = 25565;
	# 				white-list = false;
	# 			};

	# 			whitelist = default-whitelist // { };
	# 		};
	# 	};
	# };
}
