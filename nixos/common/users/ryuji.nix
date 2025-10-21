{ config, lib, pkgs, settings, pkgs-unstable, ... }:

let
	cfg = config.common.users.ryuji;

	titleCase = text: lib.concatStrings [
		(lib.toUpper (builtins.substring 0 1 text))
		(builtins.substring 1 (builtins.stringLength text) text)
	];

	uname = settings.username;
	uhome = "/home/${uname}";

	is_desk_available = lib.attrsets.hasAttrByPath [ "system" "desktop" ] config;
	desk_cfg = config.system.desktop;
	has_desktop = desk_cfg.xfce.enable || desk_cfg.hyprland.enable || desk_cfg.i3.enable;
in

{
	config = lib.mkIf cfg.enable
	{
		# NixOS (Generation 96 Nixos Uakari hyprland-24.05 (Linux 6.6), built on 2024-05-14)
		system.nixos.tags = [ "${uname}" ];

		systemd.tmpfiles.rules =
		[
#			Type Path                        Mode User     Group Age Argument
			"d   ${uhome}/Developer          0755 ${uname} users"
			"d   ${uhome}/Developer/Github   0755 ${uname} users"
			"d   ${uhome}/Developer/Projects 0755 ${uname} users"
		];

		users.users.${uname} = {
			name = uname;
			description = (titleCase uname);

			isNormalUser = true;
			createHome = true;

			initialPassword = "${uname}";
			extraGroups = [ "wheel" "dialout" "kvm" ];

			openssh.authorizedKeys.keys =
			[
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6h9IvfxHJHhzP4ifsVU3FKiqOOMOdo3xjLVZbvBGRD ryuji@jarvis"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyUySEK01xTK0S+s2u79dzVKY+p7ood622WICGhErka ryuji@quiss"

				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7 ryuji@msi"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhRn86zFXUmXsC7isRVu6WBa5t+eOvK+J7/niCZ/Wq/ ryuji@acer"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN9Ijk0y+p2Ewngw3ZIV8v0YuGkLTLA7jJXX6aYiC7D ryuji@asus"
				"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDshsbcBThxrbEKPzmv5L+S3C6TtD7Yb0KFmK6p98lFFuaWG0ATjUneBPOLa8+bjXcKrQtnfC9S6XpOQLgw3NqHxqeFTHRskgn8kIMEnsTmnTJf3G/+bIQsiBT3othh11tVadyPCUZ0K0/uN5zCqEIYXoFWy0ydHeoeE0f+3ZtWhv9megUZTBxPJWJcaVzyrPuMd1imzZiwdcSTCqtar0TjfU3s9YAJ4F06PZZ/zGNTPI4lUyXwFwHVWJj6j9tK5NVJam2rRpRVOpXY7w4PpmAMT88Uc4lrSBz1QuGCrmzajz57VbzxTxbPvjTwwXvTy/AmVFA2xvYxO4yzVWv+aFiFJsWCUaSCLu1qN/t6Xj3Hkl/jHzBkhnqXvn/xWmoje0IxTjt/WkbuPCuPtwu9vlAhYv+OT4khKopZmwBm0hdTZImFIrmT6QowWGb+7kkCRmicLxHScGDFhFSM4Dgs4qGN6B6yiUU70fTJn/5pKgM2F6KxfdqYeIFU1RnqtcC3vc= mobile@localhost"
			];
		};

		system.activationScripts =
		{
			correct-ssh-perms.text = ''
# Permission table found here
# <https://superuser.com/a/215506>

echo "Setting correct ssh permissions"
chown -R ${uname}:users ${uhome}/.ssh

chmod 700 ${uhome}/.ssh           # Folder
# chmod 600 ${uhome}/.ssh/*         # All config files
chmod 600 ${uhome}/.ssh/id_*      # All keys
chmod 644 ${uhome}/.ssh/id_*.pub  # Pub keys
'';
		};

		environment.systemPackages = with pkgs;
		[
			nix-tree
			(callPackage ../../unofficial/pkgs/schemer2.nix { })

			# (
			# 	python313Packages.callPackage ../../unofficial/pkgs/unmaniac.nix {
			# 		inherit (pkgs) git;
			# 		inherit (pkgs.nodePackages) npm;
			# 		inherit (pkgs.python.pkgs) pip;
			# 	}
			# )
		]
		++ lib.optionals (is_desk_available && has_desktop)
		[
			google-chrome
			# firefox

			obsidian

			vlc
			audacity
			emulsion

			gnome-disk-utility
			baobab

			# rustdesk
		]
		++ lib.optionals (cfg.docs-editing)    [ libreoffice ]
		++ lib.optionals (cfg.image-editing)   [ gimp krita ]
		++ lib.optionals (cfg.video-editing)   [ davinci-resolve obs-studio ]
		++ lib.optionals (cfg.game-developing) [ blender godot_4 ];
	};

	# ------------------------------------------------------------ #

	options.common.users.ryuji =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable personal user";
			default = true;
		};
		docs-editing = lib.mkOption  {
			type = lib.types.bool;
			description = "Add docs editing sofware to environment packages";
			default = false;
		};
		image-editing = lib.mkOption  {
			type = lib.types.bool;
			description = "Add image editing sofware to environment packages";
			default = false;
		};
		video-editing = lib.mkOption {
			type = lib.types.bool;
			description = "Add video editing sofware to environment packages";
			default = false;
		};
		game-developing = lib.mkOption {
			type = lib.types.bool;
			description = "Add game developing sofware to environment packages";
			default = false;
		};
	};
}
