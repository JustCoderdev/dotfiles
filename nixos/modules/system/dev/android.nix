{ config, lib, pkgs, settings, ... }:

let
	cfg = config.system.dev.android;
in

{
	config = lib.mkIf cfg.enable {

		environment.systemPackages = with pkgs; [ scrcpy ];

		programs.adb.enable = true;
		users.users.${settings.username}.extraGroups = [ "adbusers" ];
	};
}
