{ config, lib, pkgs, settings, ... }:

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
			[
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6h9IvfxHJHhzP4ifsVU3FKiqOOMOdo3xjLVZbvBGRD ryuji@jarvis"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL01mLMcme/rAl5VbJYM+dpaHm4XH3eKYgchzJ3eGsKi ryuji@quiss"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5ceb2qO05uEyS978K4xIu6Xk+cq+VoshMS8OaxVNVC ryuji@wise"

				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7 ryuji@msi"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhRn86zFXUmXsC7isRVu6WBa5t+eOvK+J7/niCZ/Wq/ ryuji@acer"
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN9Ijk0y+p2Ewngw3ZIV8v0YuGkLTLA7jJXX6aYiC7D ryuji@asus"
				"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDshsbcBThxrbEKPzmv5L+S3C6TtD7Yb0KFmK6p98lFFuaWG0ATjUneBPOLa8+bjXcKrQtnfC9S6XpOQLgw3NqHxqeFTHRskgn8kIMEnsTmnTJf3G/+bIQsiBT3othh11tVadyPCUZ0K0/uN5zCqEIYXoFWy0ydHeoeE0f+3ZtWhv9megUZTBxPJWJcaVzyrPuMd1imzZiwdcSTCqtar0TjfU3s9YAJ4F06PZZ/zGNTPI4lUyXwFwHVWJj6j9tK5NVJam2rRpRVOpXY7w4PpmAMT88Uc4lrSBz1QuGCrmzajz57VbzxTxbPvjTwwXvTy/AmVFA2xvYxO4yzVWv+aFiFJsWCUaSCLu1qN/t6Xj3Hkl/jHzBkhnqXvn/xWmoje0IxTjt/WkbuPCuPtwu9vlAhYv+OT4khKopZmwBm0hdTZImFIrmT6QowWGb+7kkCRmicLxHScGDFhFSM4Dgs4qGN6B6yiUU70fTJn/5pKgM2F6KxfdqYeIFU1RnqtcC3vc= mobile@localhost"
			];

			packages = with pkgs;
			[
				nix-tree
				(callPackage ../../unofficial/pkgs/schemer2.nix { })
			]
			++ lib.lists.optionals (self-manifest.hardware.graphics.desktop-environment.enable)
			(
				[
					firefox google-chrome
					telegram-desktop
					obsidian vlc audacity emulsion
					gnome-disk-utility gpick
					# baobab rustdesk
				]
				++ lib.lists.optionals (cfg.media-manipulation-suite.documents.enable) [ libreoffice ]
				++ lib.lists.optionals (cfg.media-manipulation-suite.images.enable)    [ gimp krita ]
				++ lib.lists.optionals (cfg.media-manipulation-suite.videos.enable)    [ davinci-resolve shotcut obs-studio ]
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
