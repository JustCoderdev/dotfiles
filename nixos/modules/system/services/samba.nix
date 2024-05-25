{ config, lib, settings, ... }:

with lib;
let
	hostname = settings.hostname;
	cfg = config.system.services.samba;
in

# User Authentication
#   For a user called my_user to be authenticated
#   on the samba server, you must add their password using
#   `smbpasswd -a my_user`

{
	config = mkIf cfg.enable {
		# Autodiscovery on windows
#		services.samba-wsdd = {
#			enable = true;
#			openFirewall = true;
#		};

		# Visible samba server in thunar
#		services.gvfs = {
#			enable = true;
#			package = lib.mkForce pkgs.gnome3.gvfs;
#		};

		services.samba = {
			enable = true;
			securityType = "user";
			openFirewall = true;
			extraConfig = ''
				server string = ${hostname}
				netbios name = ${hostname}
				hosts allow = 192.168.1. 127.0.0.1 localhost
				hosts deny = 0.0.0.0/0
				guest account = nobody
			'';
			shares = {
				public = {
					path = "/mnt/samba/public";
					browseable = "yes";
					"read only" = "yes";
					"guest ok" = "yes";
#					"create mask" = "0644";
#					"directory mask" = "0755";
#					"force user" = "guest";
#					"force group" = "guest";
				};
#				private = {
#					path = "/mnt/Shares/Private";
#					browseable = "yes";
#					"read only" = "no";
#					"guest ok" = "no";
#					"create mask" = "0644";
#					"directory mask" = "0755";
#					"force user" = "username";
#					"force group" = "groupname";
#				};
			};
		};
	};
}
