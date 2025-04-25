{ pkgs-unstable, pkgs, settings, inputs, ... }:

let
	inherit (settings) dotfiles_path username;
	mdadmhook-url-path = dotfiles_path + "/nixos/secrets/mdadmhook.url";
	duckdns-token-path = dotfiles_path + "/nixos/secrets/duckdns.token";
	cftunnel-cred-path = dotfiles_path + "/nixos/secrets/cloudflare.cred";

	raid-mount = "/mnt/md0";

	config-dir = raid-mount + "/.config";
	log-dir = raid-mount + "/.logs";
	data-dir = raid-mount + "/data";

	game-dir = data-dir + "/game";

	serv-group = "maid";
	openFirewall = true;
in

{
	imports = [
		inputs.nix-minecraft.nixosModules.minecraft-servers
	# 	../../unofficial/duckdns.nix
	];

	# nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];


	# Create service group
	users.groups."${serv-group}" = { };


	# MDADM RAID

	system.nixos.tags = [ "mdadm" ];

	# Mdadm configuration
	# <https://discourse.nixos.org/t/i-want-to-create-a-raid0-for-var-but-im-unable-to-figure-how-to-load-mdamd-on-boot/30381/5>
	boot.swraid = {
		enable = true;
		mdadmConf = ''
ARRAY /dev/md0 metadata=1.2 UUID=2789150c:8e613590:21576ee7:a7060788
PROGRAM "curl -s -X POST -H 'content-type: application/json' -d \"{ \\\"content\\\": \\\"$(date) ERROR ''${1}: ''${2}\\\" }\" \"$(cat ${mdadmhook-url-path})\""
'';
	};

	fileSystems."${raid-mount}" = {
		device = "/dev/disk/by-uuid/3e1b8cbb-9c23-4d61-a423-65245733be57";
		fsType = "ext4";
		options = [ "nofail" ];
	};

	systemd.tmpfiles.rules = [
#		Type Path                    Mode User Group
		"d   ${config-dir}           0775 root ${serv-group}"
		"d   ${log-dir}              0775 root ${serv-group}"
		"d   ${data-dir}             0775 root ${serv-group}"

		"d   ${game-dir}             0775 root ${serv-group}"

		"d   ${data-dir}/documents   0775 root ${serv-group}"
		"d   ${data-dir}/downloads   0775 root ${serv-group}"
		"d   ${data-dir}/media/movie 0775 root ${serv-group}"
		"d   ${data-dir}/media/serie 0775 root ${serv-group}"
		"d   ${data-dir}/music       0775 root ${serv-group}"
	];

	# SAMBA

	system.services = {
		samba.shares.custom = 
		let
			create-share = (name: root: owner: { inherit name root owner; });
		in
		[
			(create-share "data" raid-mount settings.username)
			# (create-share "documents" data-mount settings.username)
			# (create-share "old-ryuji-root" data-dir settings.username)
			# (create-share     "ryuji-root" data-dir settings.username)
		];
	};

	# dns records
	networking.hosts."10.0.0.1" = [ "msi.host.local" ];

	# TUNNEL

	# services.cloudflared = {
	# 	enable = true;
	# 	tunnels."local" = {
	# 		credentialsFile = "${cftunnel-cred-path}";
	# 		default = "http_status:404";
	# 		# ingress = {
	# 		# 	"*.domain1.com" = {
	# 		# 		service = "http://localhost:80";
	# 		# 	};
	# 		# };
	# 	};
	# };

	# DNS

	# services.duckdns = {
	# 	enable = true;
	# 	domains = [ "thefoxburrow" ];
	# 	tokenFile = duckdns-token-path;
	# };

	# HOST PROXY

	# networking.firewall.allowedTCPPorts = [ 80 ];
	services.nginx =
	{
		enable = true;

		# src <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>
		virtualHosts."quiss.server.local" =
		{
			locations =
			{
				"^~ /jellyfin/" = {
					proxyPass = "http://127.0.0.1:8096/";

					# <https://forum.jellyfin.org/t-nginx-proxy-manager-config?pid=42446#pid42446>
					extraConfig = ""
						+ "proxy_set_header Host $host;\n"
						+ "proxy_set_header X-Real-IP $remote_addr;\n"
						+ "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n"
						+ "proxy_set_header X-Forwarded-Proto $scheme;\n"
						+ "proxy_set_header X-Forwarded-Host $http_host;\n"
						+ "proxy_buffering off;\n";
				};
			};

			extraConfig = ""
				+ "client_max_body_size 20M;\n"
				+ "add_header X-Content-Type-Options \"nosniff\";\n"
				+ "";
		};
	};

	system.services.servarr = 
	{
		enable = true;
		inherit openFirewall;

		group = serv-group;
		data-root = data-dir;
		proxy = {
			enable = true;
			host = "quiss.server.local";
		};

		apps = {
			prowlarr.enable = true;
			deluge.enable = true;

			lidarr.enable = true;
			radarr.enable = true;

			readarr.enable = true;
			sonarr.enable = true;
		};
	};

	# MEDIA PLAYER

	services.jellyfin = {
		inherit openFirewall;
		enable = true;

		dataDir = config-dir + "/jellyfin-data";
		configDir = config-dir + "/jellyfin-config";
		logDir = log-dir + "/jellyfin";

		group = serv-group;
	};

	# MINECRAFT SERVERS

	services.minecraft-servers = {
		enable = false;
		eula = true;

		dataDir = "${game-dir}/minecraft/";

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
			};

				# <https://mcuuid.net/> <https://namemc.com>
			default-whitelist = {
				ryuji_terix = "e2458645-fb10-4065-ac0c-f689aa30adff";
			};
		in
		{
			test-1-12 = {
				enable = true;
				package = pkgs.vanillaServers.vanilla-1_12_2;
				openFirewall = true;

				jvmOpts = "-Xms4092M -Xmx6144M";

				serverProperties = default-properties // {
					level-name = "world";
					max-players = 5;
					motd = "Test vanilla 1.12.2";

					server-port = 25565;
					white-list = false;
				};

				whitelist = default-whitelist // { };
			};
		};
	};
}
