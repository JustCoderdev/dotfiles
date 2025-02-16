{ config, lib, pkgs, settings, ... }:

let
	username = settings.username;
	cfg = config.system.services.docker;
in

{
	config = lib.mkIf cfg.enable {

		environment.systemPackages = [ pkgs.docker-compose ];
		virtualisation.docker = {
			enable = true;

			# Disable iptables to use nftables
			extraOptions  = "--iptables=False";

			daemon.settings = {
				data-root = "/home/${username}/Developer/.docker/";
			};
		};

		users.users.${username}.extraGroups = [ "docker" ];
	};
}

