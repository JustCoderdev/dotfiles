{ lib, config }:

let
	cfg = config.common.core;
in

{
	config = lib.mkIf (cfg.enable)
	{
		powerManagement.enable = true;
		boot.kernelParams = [ "resume=${cfg.device}" ];

		# Suspend then hibernate
		services.power-profiles-daemon.enable = true;
		services.logind.settings.Login = {
			LidSwitch = "suspend-then-hibernate"; # Suspend first then hibernate when closing the lid
			PowerKey = "hibernate";               # Hibernate on power button pressed
			PowerKeyLongPress = "poweroff";
		};

		# Define time delay for hibernation
		systemd.sleep.settings.Sleep = {
			HibernateDelaySec = "5m";
			SuspendState = "mem";
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.hibernation =
	{
		enable = lib.mkEnableOption "hardware hibernation";
		device = lib.mkOption {
			description = "The swap device";
			example = "/dev/disk/by-label/swap";
		};
	};
}
