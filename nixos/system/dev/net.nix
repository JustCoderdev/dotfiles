{ config, lib, pkgs, settings, ... }:

let cfg = config.system.dev.net; in

{
	config = lib.mkIf cfg.enable
	{
		environment.systemPackages = with pkgs; [
			wireshark
			ethtool
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

