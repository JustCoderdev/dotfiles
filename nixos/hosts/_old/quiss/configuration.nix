{ config, lib, settings, ... }:

let
	inherit (settings) username;

	secrets = config.common.core.secrets;

#	# raid-mount = "/mnt/md0";
#	# config-dir = raid-mount + "/.config";
#	# data-dir   = raid-mount + "/data";
#
#	enable-services-touching-raid = false;
#
#	openFirewall = true;
#	forwardedServicesFirewall = false && openFirewall;
#	serv-group = "maid";
#
#	proxy = {
#		enable = true;
#		host = "quiss.home.lan";
#		aliases = [ "192.168.7.7" "10.255.250.2" "quiss.garden.lan" ];
#	};
in
{
#	networking.firewall.allowedTCPPorts = [ 443 80 25565 ];
#	services.nginx =
#	{
#		enable = true;
#		virtualHosts."${proxy.host}" =
#		let
#			vhost-secrets = secrets.nginx.vhosts."${proxy.host}";
#		in
#		{
#			# forceSSL = true;
#			addSSL = true;
#			sslCertificate = vhost-secrets.cert.path;
#			sslCertificateKey = vhost-secrets.key.path;
#		};
#	};

	# ARR Stack

#	modules.services.servarr =
#	{
#		inherit proxy;
#
#		enable = true && enable-services-touching-raid;
#		openFirewall = forwardedServicesFirewall;
#
#		group = serv-group;
#
#		config-root-dir = config-dir;
#		shared-downloads-dir = "${data-dir}/downloads";
#
#		apps =
#		{
#			prowlarr.enable = true;
#			deluge.enable = true;
#
#			lidarr.enable = true;
#			radarr.enable = true;
#			sonarr.enable = true;
#
#			bazarr.enable = false;
#			readarr.enable = false;
#		};
#	};

	# Gallery Backup

#	modules.services.immich =
#	{
#		inherit proxy;
#
#		enable = false && enable-services-touching-raid;
#		openFirewall = forwardedServicesFirewall;
#
#		config-dir = config-dir + "/immich";
#		group = serv-group;
#	};
}
