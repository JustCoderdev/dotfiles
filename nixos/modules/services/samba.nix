{ config, lib, pkgs, settings, ... }:

# Samba for macOS
# 1. <https://gist.github.com/fschiettecatte/02d61e3d36c5f8d36bd45586fc5d0dc7>
# 2. <https://wiki.samba.org/index.php/Configure_Samba_to_Work_Better_with_Mac_OS_X>
# 3. <https://www.samba.org/samba/docs/current/man-html/vfs_fruit.8.html>

# Minimal working configuration
# <https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6>

# Settings reference
# <https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>

let
	inherit (settings) username;

	cfg = config.modules.services.samba;
	# samba-root = "/srv/shares";
in

{
	config = lib.mkIf (cfg.enable)
	{
		users.users.${username}.extraGroups = [ "samba" ];
		environment.systemPackages = with pkgs; [ cifs-utils ];

# 		systemd.tmpfiles.rules =
# 		let inherit (config.services.samba.settings.public) path; in
# 		[
# #			Type Path    Mode User   Group
# 			"d   ${path} 0777 nobody nogroup"
# 		];

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

					"map to guest" = "bad user";
					"guest account" = "nobody";

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

				# public share never works
				# cannot login with any device
				# public =
				# {
				# 	comment = "Public samba share";
				# 	path = "${samba-root}/public";
				#
				# 	"read only" = "yes";
				# 	"guest only" = "yes";
				# 	"guest ok" = "yes";
				#
				# 	"force user" = "nobody";
				# 	"force group" = "nogroup";
				#
				# 	"create mask" = "0664";
				# 	"directory mask" = "0775";
				# };

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
