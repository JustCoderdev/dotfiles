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

			ingress =
			let
				create-rule = (
					subdomain: proto: port: path:
					{
						"${subdomain}.foxburrow.org" =
						{
							inherit path;
							service = "${proto}://127.0.0.1:${toString port}";
						};
					}
				);
			in
			{ }
			// (create-rule "ssh"  "ssh"   22  ".*")
			// (create-rule "home" "https" 443 "/home.*")

			// (create-rule "jellyfin" "https" 443 "/jellyfin.*")
			// (create-rule "immich"   "https" 443 ".*")

			// (create-rule "deluge"   "https" 443 "/deluge.*")
			// (create-rule "prowlarr" "https" 443 "/prowlarr.*")
			// (create-rule "bazarr"   "https" 443 "/bazarr.*")

			// (create-rule "lidarr"  "https" 443 "/lidarr.*")
			// (create-rule "radarr"  "https" 443 "/radarr.*")
			// (create-rule "readarr" "https" 443 "/readarr.*")
			// (create-rule "sonarr"  "https" 443 "/sonarr.*")
			// {};
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
				"= /home".return = "301 /home/index.html";
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
