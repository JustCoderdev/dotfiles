{ config, lib, pkgs, settings, ... }:

let
	inherit (settings) username;

	cfg = config.system.services.docker;
in

{
	config = lib.mkIf cfg.enable
	{
		environment.systemPackages = [ pkgs.docker-compose ];

		virtualisation.docker =
		{
			enable = true;
			daemon.settings.data-root = "/home/${username}/Developer/.docker/";
			extraOptions  = "--iptables=False"; # Disable iptables to use nftables
		};

		users.users.${username}.extraGroups = [ "docker" ];
	};

	# ------------------------------------------------------------ #

	options.system.services.docker = 
	{
		enable = lib.mkEnableOption "docker daemon";
	};
}

