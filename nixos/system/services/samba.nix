{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.services.samba;

	username = settings.username;
	hostname = settings.hostname;

	share-name = "${username}-${hostname}";
	share-path = "/home/${username}/${share-name}-share";
in

{
	config = lib.mkIf cfg.enable
	{
		# Autodiscovery on windows
		services.samba-wsdd = {
			enable = true;
			openFirewall = true;
		};

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

					"hosts allow" = "192.168.7.";
					"hosts deny" = "0.0.0.0/0";

					"load printers" = "no";
					"printcap name" = "/dev/null";

					"guest account" = "nobody";
					"map to guest" = "bad user";

					"browse list" = "yes";
					"case sensitive" = "yes";
					"max disk size" = "2500"; # 2.5 GB
					"min protocol" = "CORE";
				};

				"${share-name}" = {
					browseable = "yes";

					path = "${share-path}";
					comment = "${share-name}";

					"admin users" = "${username}";
					"guest ok" = "no";

					"writeable" = "yes";
					"read only" = "no";

					"create mask" = "0744";
					"directory mask" = "0755";

					"force user" = "${username}";
					"force group" = "users";

					# Apple - Share interop
					"vfs objects" = "catia fruit streams_xattr";
					"fruit:resource" = "file";
					"fruit:metadata" = "netatalk";
					"fruit:locking" = "netatalk";
					"fruit:encoding" = "native";
				};
			};
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.samba =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable samba daemon";
			default = false;
		};
	};
}
