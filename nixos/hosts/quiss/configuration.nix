{ config, lib, settings, ... }:

let
	inherit (settings) username;

	# PtP 10.255.255.252/30
	alpha-ip = "10.255.255.253";
	 beta-ip = "10.255.255.254";
	beta-port-to-alpha = "enp7s2";

	secrets = config.common.core.secrets;

	raid-mount = "/mnt/md0";
	config-dir = raid-mount + "/.config";
	data-dir   = raid-mount + "/data";

	enable-services-touching-raid = false;

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
	systemd.network = {
		enable = true;
		networks."${beta-port-to-alpha}" = {
			matchConfig.Name = beta-port-to-alpha;
			address = [ "${beta-ip}/30" ];
			linkConfig.RequiredForOnline = "no";
		};
	};

	# ---------------------------------------- #

	# Create service group
	users.groups."${serv-group}" = { };
	users.users.${username}.extraGroups = [ serv-group "minecraft" ];

	systemd.tmpfiles.rules = [
#		Type Path                    Mode User Group
		"d   ${config-dir}           0775 root ${serv-group}"
		"d   ${data-dir}             0775 root ${serv-group}"

		"d   ${data-dir}/documents   0775 root ${serv-group}"
		"d   ${data-dir}/games       0775 root minecraft"

		# App dirs
		"d   ${data-dir}/downloads   0775 root ${serv-group}"
		"d   ${data-dir}/media/movie 0775 root ${serv-group}"
		"d   ${data-dir}/media/serie 0775 root ${serv-group}"
		"d   ${data-dir}/music       0775 root ${serv-group}"
		"d   ${data-dir}/books       0775 root ${serv-group}"
	];


	# Spindown after 10 minutes
	# systemd.services.hd-idle = let
	# 	time_m = 10;
	# 	time_s = toString (time_m * 60);
	# in {
	# 	enable = true;
	# 	wantedBy = [ "multi-user.target" ];
	# 	serviceConfig = {
	# 		type = "forking";
	# 		ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sdb -i ${time_s} -a sdc -i ${time_s}";
	# 	};
	# };

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

	networking.firewall.allowedTCPPorts = [ 443 80 25565 ];
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

		enable = true && enable-services-touching-raid;
		openFirewall = forwardedServicesFirewall;

		group = serv-group;

		config-root-dir = config-dir;
		shared-downloads-dir = "${data-dir}/downloads";

		apps =
		{
			prowlarr.enable = true;
			deluge.enable = true;

			lidarr.enable = true;
			radarr.enable = true;
			sonarr.enable = true;

			bazarr.enable = false;
			readarr.enable = false;
		};
	};

	# MEDIA PLAYER

	modules.services.jellyfin =
	{
		inherit proxy;

		enable = true && enable-services-touching-raid;
		openFirewall = forwardedServicesFirewall;

		config-dir = config-dir + "/jellyfin";
		group = serv-group;
	};

	# Gallery Backup

	modules.services.immich =
	{
		inherit proxy;

		enable = false && enable-services-touching-raid;
		openFirewall = forwardedServicesFirewall;

		config-dir = config-dir + "/immich";
		group = serv-group;
	};

	# services.syncthing.guiAddress = "10.255.250.2:8384";
	modules.services.syncthing =
	{
		enable = lib.mkForce (true && enable-services-touching-raid);
		inherit openFirewall;
		group = serv-group;
	};

	services.grafana.enable = false;
}
