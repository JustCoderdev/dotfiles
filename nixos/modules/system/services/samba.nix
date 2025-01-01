{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.services.samba;
	username = settings.username;
	hostname = settings.hostname;
	share-path = "/home/${username}/share";
in

# User Authentication
#   For a user called my_user to be authenticated
#   on the samba server, you must add their password using
#   `smbpasswd -a my_user`

{
	config = lib.mkIf cfg.enable {
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

		environment.systemPackages = with pkgs; [
			cifs-utils
			keyutils
		];

		systemd.tmpfiles.rules = [
#			Type Path           Mode User        Group Age Argument
			"d   ${share-path}  0755 ${username} users"
		];

		services.samba = {
			enable = true;
			openFirewall = true;

			settings = {
				"global" = {
					security = "user";

					"hosts allow" = [
						"127.0.0.1" "localhost" # "192.168.7."
					];

					"hosts deny" = "0.0.0.0/0";

					"load printers" = "no";
					"printcap name" = "/dev/null";

					"guest account" = "nobody";
					"map to guest" = "bad user";
				};

				"${username}-${hostname}" = {
					path = "${share-path}";
					browseable = "yes";

					"read only" = "no";
					"guest ok" = "no";

					"create mask" = "0644";
					"directory mask" = "0755";

					"force user" = "${username}";
					"force group" = "users";
				};

#				public = {
#					path = "/mnt/samba/public";
#					browseable = "yes";
#					"read only" = "yes";
#					"guest ok" = "yes";
#
##					"create mask" = "0644";
##					"directory mask" = "0755";
#
#					"force user" = "nobody";
#					"force group" = "nogroup";
#				};

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

#		fileSystems."/mnt/samba-server/${settings.username}" = {
#			device = "//samba.service.local/ryuji";
#			fsType = "cifs";
#			options = let # this line prevents hanging on network split
#				automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
#			in [
#				"${automount_opts},credentials=/etc/nixos/smb-secrets"
#			];
#		};
	};
}
