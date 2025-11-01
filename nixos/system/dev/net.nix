{ config, lib, pkgs, settings, ... }:

let
	dev-cfg = config.system.dev;
	cfg = dev-cfg.net;
in

{
	config = lib.mkIf (dev-cfg.enable && cfg.enable)
	{
		environment.systemPackages = with pkgs;
		[
			wireshark
			ethtool
			nmap
		];

		# Wireshark
		programs.wireshark.enable = true;
		users.users.${settings.username}.extraGroups = [ "wireshark" "pcap" ];
		users.groups.wireshark = { };

		# Packet sniffer
		programs.tcpdump.enable = true;
		# users.users.${settings.username}.extraGroups = [ "pcap" ];
	};

	# ------------------------------------------------------------ #

	options.system.dev.net = 
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add network development tools and apps";
			default = false;
		};
	};
}

