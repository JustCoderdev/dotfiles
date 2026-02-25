{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) username;

	cfg = config.common.environments.development;
in

{
	config = lib.mkIf (cfg.enable)
	{
		systemd.tmpfiles.rules =
		let
			uhome = "/home/${username}";
		in
		[
#			Type Path                        Mode User     Group Age Argument
			"d   ${uhome}/Developer          0755 ${username} users"
			"d   ${uhome}/Developer/Github   0755 ${username} users"
			"d   ${uhome}/Developer/Projects 0755 ${username} users"
		];

		environment.systemPackages = with pkgs; [ screen ]
		++ lib.lists.optionals (cfg.tools.android.enable) [ scrcpy ]
		++ lib.lists.optionals (cfg.tools.network.enable) [ wireshark ethtool nmap ]
		++ lib.lists.optionals (cfg.tools.game-development.enable) [ blender godot_4 ]
		++ lib.lists.optionals (cfg.tools.c.enable)
		[
			# Docs
			glibc glibcInfo
			man-pages man-pages-posix
			clang-manpages linux-manual
			stdmanpages stdman

			# Compilation
			clang-tools clang
			gcc gnumake nasm

			# Tools
			ascii ripgrep

			# Debugging
			gdb valgrind
			gf file
		]
		++ lib.lists.optionals (cfg.tools.java.enable)
		[
			jetbrains.idea-ultimate
			javaPackages.compiler.openjdk23
			javaPackages.openjfx23
		]
		;

		users.users.${username}.extraGroups = []
		++ lib.lists.optionals (cfg.tools.network.enable) [ "wireshark" "pcap" ]
		++ lib.lists.optionals (cfg.tools.android.enable) [ "adbusers" ]
		;

		# -------------------- #


		# Android
		programs.adb.enable = cfg.tools.android.enable;
		# boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];
		# services.udev.packages = [ pkgs.android-udev-rules ];


		# C
		documentation = lib.mkIf (cfg.tools.c.enable)
		{
			enable = true;
			nixos.enable = true;
			dev.enable = true;

			# providers
			doc.enable = true;
			info.enable = true;
			man.enable = true;
		};


		# Network
		programs.wireshark.enable = cfg.tools.network.enable;
		programs.tcpdump.enable = cfg.tools.network.enable;
	};

	# ------------------------------------------------------------ #

	options.common.environments.development =
	{
		enable = lib.mkEnableOption "the development environment";
		tools = {
			android.enable = lib.mkEnableOption "android tools";
			c.enable = lib.mkEnableOption "c tools";
			game-development.enable = lib.mkEnableOption "game development tools";
			java.enable = lib.mkEnableOption "java ide";
			network.enable = lib.mkEnableOption "network tools";
		};
	};
}
