{ config, pkgs, settings, ... }:

let
	inherit (settings) username;

	secrets = config.common.core.secrets;

	raid-mount = "/mnt/md0";
	config-dir = raid-mount + "/.config";
	data-dir   = raid-mount + "/data";

	openFirewall = false;
	serv-group = "maid";

	proxy = {
		enable = true;
		host = "quiss.home.lan";
		aliases = [ "192.168.7.7" "10.255.250.2" ];
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

		"d   ${data-dir}/documents   0775 root ${serv-group}"

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

	system.services.samba.shares.custom = let
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

	system.services.servarr =
	{
		inherit openFirewall proxy;
		enable = true;

		group = serv-group;

		config-root-dir = config-dir;
		shared-downloads-dir = "${data-dir}/downloads";

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

	system.services.syncthing =
	{
		inherit openFirewall;
		enable = true;

		dataDir = "${data-dir}/documents/synced";
		group = serv-group;

		folders = [ "obsidian-db" ];
		devices =
		let
			add-device = (address: id: { inherit address id; });
		in
		{
			        quiss = (add-device "10.255.250.2" "OM3LICW-TEP5TOM-O2C4I5L-RE67TTX-CUD7TFZ-H4YHNKX-LOKOUMT-MFLJHAK");
			iphone-tp-2_0 = (add-device "10.255.250.3" "MBQSGMY-3EBNA67-XQLOXDU-UT3QL7Y-4MQO633-YOOEA5U-LT5RFVC-JYGAXQH");
			         asus = (add-device "10.255.250.4" "KTEN4FK-LK6SURY-N46K2Z6-5HTCGVR-24OPTRW-QFQBIVI-HFLYW2L-NE6W6Q7");
			          msi = (add-device "10.255.250.5" "LGPPAMZ-TLOK2XH-JKCAXZQ-WLXTAAN-3SFRHCV-7AL7FBZ-B4EHV3E-MSRBHAI");
			  ipad-tp-2_0 = (add-device "dynamic"      "WNA7TTR-2GZ7QRH-4HXPAJT-QAI7VVM-MCX3ZFC-WPXG3UB-CGMPF4C-YKTCSA7");
		};
	};

	# MINECRAFT SERVER
	# <https://minecraft.fandom.com/wiki/Server.properties#Java_Edition_3>
	# <https://mcuuid.net/> <https://namemc.com>
}
