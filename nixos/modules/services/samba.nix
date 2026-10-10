{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) username;

	cfg = config.modules.services.samba;
	samba-root = "/srv/shares";
in

{
	config = lib.mkIf (cfg.enable)
	{
		users.users.${username}.extraGroups = [ "samba" ];
		environment.systemPackages = with pkgs; [ cifs-utils ];

		systemd.tmpfiles.rules =
		let inherit (config.services.samba.settings.public) path; in
		[
#			Type Path    Mode User  Group
			"d   ${path} 0755 samba samba"
		];

		# Autodiscovery on windows
		services.samba-wsdd = {
			enable = true;
			openFirewall = true;
		};

		services.samba =
		{
			enable = true;
			package = pkgs.samba4Full;
			openFirewall = true;

			usershares.enable = true;

			settings =
			{
				global =
				{
					"browseable" = "yes";
					"read only" = "no";
					"guest ok" = "no";

					"server smb encrypt" = "required";
					"server min protocol" = "SMB3_00";
					"workgroup" = "WORKGROUP";

					# Apple - Share interop
					"vfs objects" = "catia fruit streams_xattr";
					"fruit:resource" = "file";
					"fruit:metadata" = "netatalk";
					"fruit:locking" = "netatalk";
					"fruit:encoding" = "native";
				};

				homes."browseable" = "no";

				public =
				{
					comment = "Public samba share";
					path = "${samba-root}/public";

					"read only" = "yes";
					"guest ok" = "yes";
				};

				# testshare = {
				# 	"path" = "/home/<USER>/Public";
				# 	"writable" = "yes";
				# 	"comment" = "Hello World!";
				# 	"browseable" = "yes";
				#
				# 	"valid users" = username;
				# };
			}
			//
			builtins.mapAttrs (
				name: path:
				{
					comment = name;
					path = "${path}/${name}";
					"valid users" = username;
				}
			) cfg.shares
			;
		};

		services.avahi =
		{
			enable = true;
			openFirewall = true;

			publish = {
				enable = true;
				userServices = true;
			};
		};
	};

	# ------------------------------------------------------------ #

	options.modules.services.samba =
	{
		enable = lib.mkEnableOption "Enable samba daemon";
		shares = lib.mkOption {
			default = { };
			description = "Extra custom shares";
			type = lib.types.attrsOf lib.types.str;
		};
	};
}
