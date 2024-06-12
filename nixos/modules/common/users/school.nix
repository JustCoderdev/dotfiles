{ config, lib, pkgs, ... }:

let
#	username = "school";
	cfg = config.common.users.school;
in {

	config = lib.mkIf cfg.enable {
#		users.users.${username} = {
#			name = username;
#			description = username;
#
#			isNormalUser = true;
#			createHome = false;
#
#			extraGroups = [ "networkmanager" ];
#			# packages = with pkgs; [ ];
#		};
#
		# List packages installed in system profile.
		environment.systemPackages = with pkgs; [
			google-chrome
			# ciscoPacketTracer8
			# github-desktop
			# vscode
		];
	};
}
