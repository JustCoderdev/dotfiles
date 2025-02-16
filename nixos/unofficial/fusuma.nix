# Unofficial module by jonringer
# src: <https://discourse.nixos.org/t/how-to-start-a-daemon-properly-in-nixos/14019/2>

{ pkgs, lib, config, ... }:

let
	cfg = config.services.fusuma;
	configFile = pkgs.writeText "config.yml" cfg.settings;
in

{
	options.services.fusuma = {
		enable = lib.mkEnableOption "Enable fusuma service";

		package = lib.mkOption {
			type = lib.types.package;
			default = pkgs.fusuma;
			defaultText = "pkgs.fusuma";
			description = "Set version of fusuma package to use.";
		};

		settings = lib.mkOption {
			type = lib.types.str;
			default = '''';
			description = "Add settings for fusuma";
		};
	};

	config = lib.mkIf cfg.enable {
		environment.systemPackages = [ cfg.package ]; # if user should have the command available as well
		services.dbus.packages = [ cfg.package ]; # if the package has dbus related configuration

		systemd.services.fusuma = {
			description = "Fusuma server daemon.";

			wantedBy = [ "multi-user.target" ];
			after = [ "network.target" ]; # if networking is needed

			restartIfChanged = true; # set to false, if restarting is problematic

			serviceConfig = {
				DynamicUser = true;
				ExecStart = "${cfg.package}/bin/fusuma --config=${configFile}";
				Restart = "always";
			};
		};
	};

#	meta.maintainers = with lib.maintainers; [	];
}
