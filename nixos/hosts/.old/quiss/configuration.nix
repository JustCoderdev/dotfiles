{ config, lib, pkgs, settings, nix-minecraft, ... }:

let
	inherit (settings) username;

	secrets = config.common.core.secrets;

	raid-mount = "/mnt/md0";
	config-dir = raid-mount + "/.config";
	data-dir   = raid-mount + "/data";

	openFirewall = true;
	forwardedServicesFirewall = false && openFirewall;
	serv-group = "maid";

	proxy = {
		enable = true;
		host = "quiss.home.lan";
		aliases = [ "192.168.7.7" "10.255.250.2" "quiss.garden.lan" ];
	};
in
{
	# Create service group
	users.groups."${serv-group}" = { };
	users.users.${username}.extraGroups = [ serv-group ];

	systemd.tmpfiles.rules = [
#		Type Path                    Mode User Group
		"d   ${config-dir}           0775 root ${serv-group}"
		"d   ${data-dir}             0775 root ${serv-group}"

		"d   ${data-dir}/documents   0775 root ${serv-group}"
		"d   ${data-dir}/games       0775 root ${serv-group}"

		# App dirs
		"d   ${data-dir}/downloads   0775 root ${serv-group}"
		"d   ${data-dir}/media/movie 0775 root ${serv-group}"
		"d   ${data-dir}/media/serie 0775 root ${serv-group}"
		"d   ${data-dir}/music       0775 root ${serv-group}"
		"d   ${data-dir}/books       0775 root ${serv-group}"
	];


	# Spindown after 10 minutes
	systemd.services.hd-idle = let
		time_m = 10;
		time_s = toString (time_m * 60);
	in {
		enable = true;
		wantedBy = [ "multi-user.target" ];
		serviceConfig = {
			type = "forking";
			ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sdb -i ${time_s} -a sdc -i ${time_s}";
		};
	};

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
			ingress."quiss-cf.foxburrow.org".service = "ssh://127.0.0.1:22";
		};
	};

	# ------------------------------------------------------------ #

	# SAMBA

	modules.services.samba.shares.custom = let
		create-share = (name: root: owner: { inherit name root owner; });
	in [
		(create-share "data" raid-mount username)
	];

	# Homepage
	# <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>

	networking.firewall.allowedTCPPorts = [ 443 80 ];
	services.nginx =
	{
		enable = true;
		virtualHosts."${proxy.host}" =
		let
			vhost-secrets = secrets.nginx.vhosts."${proxy.host}";
		in
		{
			# forceSSL = true;
			addSSL = true;
			sslCertificate = vhost-secrets.cert.path;
			sslCertificateKey = vhost-secrets.key.path;
		};
	};

	# ARR Stack

	modules.services.servarr =
	{
		inherit proxy;

		enable = true;
		openFirewall = forwardedServicesFirewall;

		group = serv-group;

		config-root-dir = config-dir;
		shared-downloads-dir = "${data-dir}/downloads";

		apps = {
			prowlarr.enable = true;
			deluge.enable = true;
			bazarr.enable = false;

			lidarr.enable = true;
			radarr.enable = true;
			readarr.enable = true;
			sonarr.enable = true;
		};
	};

	# MEDIA PLAYER

	modules.services.jellyfin =
	{
		inherit proxy;

		enable = true;
		openFirewall = forwardedServicesFirewall;

		config-dir = config-dir + "/jellyfin";
		group = serv-group;
	};

	# Gallery Backup

	modules.services.immich =
	{
		inherit proxy;

		enable = false;
		openFirewall = forwardedServicesFirewall;

		config-dir = config-dir + "/immich";
		group = serv-group;
	};

	# services.syncthing.guiAddress = "10.255.250.2:8384";
	modules.services.syncthing =
	{
		inherit openFirewall;
		dataDir = "${data-dir}/documents/synced";
		group = serv-group;
	};

	services.grafana.enable = true;


	# Temporary services
	# ------------------------------------------------------------ #

	# MINECRAFT SERVERS

	# imports = [ nix-minecraft.nixosModules.minecraft-servers ];
	# nixpkgs.overlays = [ nix-minecraft.overlay ];

	# services.minecraft-servers =
	# {
	# 	enable = false;
	# 	openFirewall = true;
	# 	eula = true;

	# 	dataDir = data-dir + "/games/minecraft";

	# 	servers =
	# 	let
	# 		# <https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3>
	# 		default-properties =
	# 		{
	# 			allow-flight = true;
	# 			force-gamemode = false;
	# 			player-idle-timeout = 0;

	# 			snooper-enabled = false;
	# 			online-mode = false;
	# 			use-native-transport = true;
	# 			verify-names = false;

	# 			white-list = false;
	# 			enforce-whitelist = false;
	# 		};

	# 		# <https://mcuuid.net/> <https://namemc.com>
	# 		ryuji-uuid = "e2458645-fb10-4065-ac0c-f689aa30adff";
	# 		default-whitelist = { Ryuji_terix = ryuji-uuid; };
	# 		default-operators = { Ryuji_terix = ryuji-uuid; };
	# 	in
	# 	{
	# 		project-genesis =
	# 		let
	# 			modpack = pkgs.fetchPackwizModpack { src = ./project-genesis; };

	# 			mcVersion = modpack.manifest.versions.minecraft;
	# 			forgeVersion = modpack.manifest.versions.forge;
	# 			serverVersion = lib.replaceStrings [ "." ] [ "_" ] "forge-${mcVersion}";
	# 		in
	# 		{
	# 			enable = false;
	# 			package = pkgs.forgeServers.${serverVersion}.override { loaderVersion = forgeVersion; };

	# 			openFirewall = true;

	# 			autoStart = false;
	# 			jvmOpts = "-Xms4092M -Xmx6144M";

	# 			operators = default-operators // { };
	# 			whitelist = default-whitelist // { };

	# 			serverProperties = default-properties
	# 			// {
	# 				server-port = 25565;
	# 				motd = "PJ Genesis";

	# 				level-name = "world";
	# 				difficulty = 3; # peaceful, easy, normal, hard
	# 				gamemode = 0; # survival, creative, adventure, spectator

	# 				view-distance = 20;
	# 				max-players = 5;
	# 			};

	# 			symlinks."mods" = "${modpack}/mods";
	# 			files = nix-minecraft.lib.collectFilesAt modpack "config";
	# 		};
	# 	};
	# };
}
