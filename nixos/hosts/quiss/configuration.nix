{ pkgs-unstable, pkgs, settings, inputs, ... }:

let
	inherit (settings) dotfiles_path username;
	cftunnel-cred-path = dotfiles_path + "/nixos/secrets/cloudflare.cred";
	cfdomain = "foxburrow.org";

	raid-mount = "/mnt/md0";
	config-dir = raid-mount + "/.config";
	data-dir   = raid-mount + "/data";
	downloads-dir = data-dir + "/downloads";
	backup-dir    = data-dir + "/.backup";
	game-dir      = data-dir + "/game";

	openFirewall = true;
	serv-group = "maid";
	proxy = {
		enable = false;
		host = cfdomain;
	};
in

{
	# imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
	# nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

	# ------------------------------------------------------------ #

	# TUNNEL

	services.cloudflared = {
		enable = true;
		tunnels."home" =
		let
			services =
			[
				# { name =      "ssh";  port = 22;   }
				{ name =      "www";  port = 80;   }
				# { name =    "samba";  port = 443;  }

				# { name = "jellyfin";  port = 8096; }
				# { name =   "deluge";  port = 8112; }
				# { name = "prowlarr";  port = 9696; }

				# { name =   "radarr";  port = 7878; }
				# { name =   "lidarr";  port = 8686; }
				# { name =  "readarr";  port = 8787; }
				# { name =   "sonarr";  port = 8989; }
			];
		in
		{
			credentialsFile = "${cftunnel-cred-path}";
			default = "http_status:404";
			ingress = (
				(
					builtins.listToAttrs (
						builtins.map (
							{ name, port }:
							{
								name  = "${name}.${cfdomain}";
								value = "http://127.0.0.1:${toString port}";
							}
						) services
					)
				)
				//
				{ "*" = "http_status:404"; }
			);
		};
	};

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
		"d   ${backup-dir}           0775 root ${serv-group}"
		"d   ${data-dir}/documents   0775 root ${serv-group}"

		"d   ${data-dir}/media/movie 0775 root ${serv-group}"
		"d   ${data-dir}/media/serie 0775 root ${serv-group}"
		"d   ${data-dir}/music       0775 root ${serv-group}"
		"d   ${data-dir}/books       0775 root ${serv-group}"
	];

	# ------------------------------------------------------------ #

	# SAMBA

	system.services.samba.shares.custom =
	let
		create-share = (name: root: owner: { inherit name root owner; });
	in
	[
		(create-share "data" raid-mount settings.username)
	];

	# Homepage
	# <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>

	networking.firewall.allowedTCPPorts = [ 80 ];
	services.nginx = {
		enable = true;
		virtualHosts."www.${cfdomain}".root = data-dir + "/homepage";
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
