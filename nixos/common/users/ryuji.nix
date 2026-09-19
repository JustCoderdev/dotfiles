{ config, lib, pkgs, settings, pkgs-unstable, ... }:

let
	inherit (settings) username;

	cfg = config.common.users.ryuji;
	self-manifest = config.common.manifest.self;

	uhome = "/home/${username}";
in

{
	config = lib.mkIf (cfg.enable)
	{
		system.nixos.tags = [ "${username}" ];
		jcconfs.users = [ "${username}"  ];

		nix.settings.trusted-users = [ "${username}" ];

		users.users.${username} =
		let
			titleCase = text: lib.concatStrings [
				(lib.toUpper (builtins.substring 0 1 text))
				(builtins.substring 1 (builtins.stringLength text) text)
			];
		in
		{
			description = (titleCase username);
			isNormalUser = true;

			#                root    serial
			extraGroups = [ "wheel" "dialout" ];
			initialPassword = "${username}";

			openssh.authorizedKeys.keys =
			let
				inherit (config.common.manifest) hosts;
				get-pubkey-or-null = (
					keyname: hostname:
					let
						inherit (hosts.${hostname}.software.ssh) pubkey;
						has-pubkey = builtins.hasAttr keyname pubkey;
					in
					if has-pubkey
						then pubkey.${keyname} + " ${keyname}@${hostname}"
						else null
				);
			in
			[ ]
			++
			builtins.filter (key: key != null)
			(
				builtins.map
					(hostname: get-pubkey-or-null "ryuji" hostname)
					(builtins.attrNames hosts)
			)
			;

			packages = [ ]
			++ lib.lists.optionals
				(self-manifest.hardware.graphics.desktop-environment.enable)
				(with pkgs-unstable; [ obsidian ])
			++
			(
				with pkgs;
				[
					nix-tree btop unixtools.netstat
					appimage-run imagemagick # dust
				]
				++ lib.lists.optionals (self-manifest.hardware.graphics.desktop-environment.enable)
				(
					[
						firefox google-chrome
						vlc audacity emulsion
						gnome-disk-utility gpick
						qemu baobab # rustdesk
					]
					++ lib.lists.optionals (cfg.media-manipulation-suite.documents.enable) [ libreoffice ]
					++ lib.lists.optionals (cfg.media-manipulation-suite.images.enable)    [ gimp krita ]
					++ lib.lists.optionals (cfg.media-manipulation-suite.videos.enable)    [ shotcut obs-studio ] # davinci-resolve
				)
			);
		};

		system.userActivationScripts =
		{
			correct-ssh-dir-perms.text = ''
# Permission table found here
# <https://superuser.com/a/215506>

echo "correcting permissions for '${uhome}/.ssh'"

chown -R ${username}:users ${uhome}/.ssh
chmod 700 ${uhome}/.ssh           # Folder
chmod 600 ${uhome}/.ssh/id_*      # All keys
chmod 644 ${uhome}/.ssh/id_*.pub  # Pub keys
'';
		};

		programs.ssh.extraConfig = ''
Host dip.rxserver.net
	HostName dip.rxserver.net
	IdentitiesOnly yes # Force to use only this identity file
	IdentityFile "${uhome}/.ssh/id_github_justcode"
'';

		# -------------------- #

		assertions = [ {
			assertion = username == "ryuji";
			message = "The username must be 'ryuji'!";
		} ];
	};

	# ------------------------------------------------------------ #

	options.common.users.ryuji =
	{
		enable = lib.mkEnableOption "ryuji personal user" // { default = true; };
		media-manipulation-suite =
		{
			documents.enable = lib.mkEnableOption "document manipulation suite";
			images.enable = lib.mkEnableOption "image manipulation suite";
			videos.enable = lib.mkEnableOption "video manipulation suite";
		};
	};
}
