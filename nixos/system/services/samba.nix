{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) username;

	cfg = config.system.services.samba;

	hostname = config.networking.hostName;
	share-root = "/home/${username}";
in

{
	config = lib.mkIf (cfg.enable)
	{
		# Autodiscovery on windows
		services.samba-wsdd = {
			enable = false;
			openFirewall = true;
		};

		# Autodiscovery with avahi
		# services.avahi.extraServiceFiles.smb = ''
# <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
# <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
# <service-group>
	# <name replace-wildcards="yes">%h</name>
	# <service>
		# <type>_smb._tcp</type>
		# <port>445</port>
	# </service>
# </service-group>
# '';


		environment.systemPackages = with pkgs; [
			cifs-utils
			keyutils
		];

		# Allow discovery
		networking.firewall.extraCommands = lib.mkIf (!config.networking.nftables.enable) ''
iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
'';

		systemd.tmpfiles.rules = [ ]
		++
		(
			lib.optionals (cfg.shares.user.enable) [
#				Type Path                                        Mode User        Group
				"d   ${share-root}/${username}-${hostname}-share 0755 ${username} users"
			]
		)
		++
		(
			builtins.map (
				share:
#				Type Path                        Mode User           Group
				"d   ${share.root}/${share.name} 0755 ${share.owner} users"
			) cfg.shares.custom
		);


		services.samba =
		let
			default-settings = {
				"browseable" = "yes";
				"guest ok" = "no";

				"writeable" = "yes";
				"read only" = "no";

				"create mask" = "0744";
				"directory mask" = "0755";

				# Apple - Share interop
				"vfs objects" = "catia fruit streams_xattr";
				"fruit:resource" = "file";
				"fruit:metadata" = "netatalk";
				"fruit:locking" = "netatalk";
				"fruit:encoding" = "native";
			};

			create-share = (
				name: root-path: owner:
				(default-settings) // {
					"path" = "${root-path}/${name}";
					"comment" = "${name}";

					"admin users" = "${owner}";

					"force user" = "${owner}";
					"force group" = "users";
				}
			);
		in
		{
			enable = true;
			package = pkgs.samba4Full;
			openFirewall = true;

			settings = builtins.listToAttrs (
				[
					{
						name = "global";
						value =
						{
							"security" = "user";

							"hosts allow" = "192.168., 10., 172.";
							"hosts deny" = "0.0.0.0/0";

							"load printers" = "no";
							"printcap name" = "/dev/null";

							"guest account" = "nobody";
							"map to guest" = "bad user";

							"browse list" = "yes";
							"case sensitive" = "yes";
							"max disk size" = "2500"; # 2.5 GB
							"name resolve order" = "host lmhosts wins bcast";
						};
					}
				]
				++
				(
					let name = "${username}-${hostname}-share"; in
					lib.optionals (cfg.shares.user.enable)
					[
						{
							inherit name;
							value = create-share name share-root username;
						}
					]
				)
				++
				builtins.map (
					share:
					{
						inherit (share) name;
						value = create-share share.name share.root share.owner;
					}
				) cfg.shares.custom
			);
		};
	};

	# ------------------------------------------------------------ #

	options.system.services.samba =
	{
		enable = lib.mkEnableOption "Enable samba daemon";
		shares = {
			user.enable = lib.mkEnableOption "Create default user share";
			custom = lib.mkOption {
				default = [];
				description = "Custom shares";
				type = lib.types.listOf (
					lib.types.submodule (
						{ config, ... }:
						{
							options = {
								name = lib.mkOption {
									type = lib.types.str;
									description = "The name of the share";
								};
								root = lib.mkOption {
									type = lib.types.str;
									description = "The path to the root directory of the share";
									default = "${share-root}";
								};
								owner = lib.mkOption {
									type = lib.types.str;
									description = "Owner of the share";
									default = "${username}";
								};
							};
						}
					)
				);
			};
		};
	};
}
