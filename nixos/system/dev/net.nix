{ config, lib, pkgs, settings, ... }:

let cfg = config.system.dev.net; in

{
	config = lib.mkIf cfg.enable {

		environment.systemPackages = with pkgs; [
			wireshark
			ethtool
		];


		# Wireshark
		programs.wireshark.enable = true;
		users.users.${settings.username}.extraGroups = [ "wireshark" ];
		users.groups.wireshark = { };
	};
}

