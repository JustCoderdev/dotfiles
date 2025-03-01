{ settings, ... }:

let
	inherit (settings) dotfiles_path;
	mdadmhook-url-path = dotfiles_path + "/nixos/secrets/mdadmhook.url";
	duckdns-token-path = dotfiles_path + "/nixos/secrets/duckdns.token";
in

{
	# imports = [
	# 	../../unofficial/duckdns.nix
	# ];

	# MDADM RAID

	system.nixos.tags = [ "mdadm" ];

	# Mdadm configuration
	# <https://discourse.nixos.org/t/i-want-to-create-a-raid0-for-var-but-im-unable-to-figure-how-to-load-mdamd-on-boot/30381/5>
	boot.swraid = {
		enable = true;
		mdadmConf = ''
ARRAY /dev/md0 metadata=1.2 UUID=2789150c:8e613590:21576ee7:a7060788
PROGRAM curl -s -X POST -H 'content-type: application/json' -d "{ \"content\": \"$(date) ERROR $${1}: $${2}\" }" "$(cat ${mdadmhook-url-path})"
'';
	};

#	fileSystems."/mnt/md0" = {
#		device = "/dev/disk/by-uuid/3e1b8cbb-9c23-4d61-a423-65245733be57";
#		fsType = "ext4";
#	};
 
	# DNS
	
	# services.duckdns = {
	# 	enable = true;
	# 	domains = [ "thefoxburrow" ];
	# 	tokenFile = duckdns-token-path;
	# };

	# HTTP HOST

	#networking.firewall.allowedTCPPorts = [ 80 443 ];
	#services.nginx = {
	#	enable = true;

	#	# src <https://nixos.org/manual/nixos/stable/#module-security-acme-nginx>
	#	virtualHosts = {
	#		"quiss.host.local" = {
	#			addSSL = true;
	#			enableACME = true;
	#			serverAliases = [ "thefoxburrow.duckdns.org" ];
	#			root = "/var/www/blog";
	#		};
	#	};
	#};

#	security.acme = {
#		acceptTerms = true;
#		defaults.email = "107036402+JustCoderdev@users.noreply.github.com";
#	};
}
