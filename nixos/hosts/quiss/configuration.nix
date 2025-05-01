{ pkgs-unstable, pkgs, settings, inputs, ... }:

let
	unstable-path = inputs.nixpkgs-unstable.outPath;

	inherit (settings) dotfiles_path username;
	cftunnel-cred-path = dotfiles_path + "/secrets/cloudflare/722afdef-b269-406d-9b56-66a36a01120e.json";
	cftunnel-cert-path = dotfiles_path + "/secrets/cloudflare/cert.pem";
	# cf-dns-token-path  = dotfiles_path + "/secrets/cloudflare/acme-auth.token";
	cfdomain = "foxburrow.org";

	raid-mount = "/mnt/md0";
	config-dir = raid-mount + "/.config";
	data-dir   = raid-mount + "/data";
	downloads-dir = data-dir + "/downloads";
	game-dir      = data-dir + "/game";

	openFirewall = true;
	serv-group = "maid";
	proxy = {
		enable = true;
		host = "quiss.server.local";
	};
in

{
	disabledModules = [ "services/networking/cloudflared.nix" ];
	imports = [ 
		# "${unstable-path}/nixos/modules/services/networking/cloudflared.nix"
		../../unofficial/cloudflared.nix
	];

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
		certificateFile = "${cftunnel-cert-path}";

		tunnels."home" =
		{
			credentialsFile = "${cftunnel-cred-path}";
			default = "http_status:404";
			ingress = 
			{
				     "foxburrow.org".service = "http://127.0.0.1:80";
				 "www.foxburrow.org".service = "http://127.0.0.1:80";
				"home.foxburrow.org".service = "http://127.0.0.1:80";

				"jellyfin.foxburrow.org".service = "http://127.0.0.1:8096";
				  "deluge.foxburrow.org".service = "http://127.0.0.1:8112";
				"prowlarr.foxburrow.org".service = "http://127.0.0.1:9696";

				 "radarr.foxburrow.org".service = "http://127.0.0.1:7878";
				 "lidarr.foxburrow.org".service = "http://127.0.0.1:8686";
				"readarr.foxburrow.org".service = "http://127.0.0.1:8787";
				 "sonarr.foxburrow.org".service = "http://127.0.0.1:8989";
			};
		};
	};

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
	# security.acme = {
	# 	acceptTerms = true;
	# 	defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
	# 	certs."${proxy.host}" = {
	# 		# dnsProvider = "cloudflare";
	# 		# environmentFile = cf-dns-token-path;
	# 	};
	# };
	services.nginx = {
		enable = true;
		virtualHosts."${proxy.host}" =
		{
			# forceSSL = true;
			# enableACME = true;
			locations."/".root = data-dir + "/homepage";
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
