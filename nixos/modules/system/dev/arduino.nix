{ config, lib, pkgs, settings, ... }:

with lib;
let cfg = config.system.dev.arduino; in

{
	config = mkIf cfg.enable {
		assertions = [{
			assertion = config.system.dev.c.enable;
			message = "Arduino tools require to enable c tools";
		}];

		environment.systemPackages = with pkgs; [
			arduino
			screen
		];

		# Grant permission to read serial devices /dev/ttyACM0
		users.users.${settings.username}.extraGroups = [ "dialout" ];
	};
}
