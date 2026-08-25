{ config, lib, ... }:

let
	is-laptop = config.common.manifest.self.hardware.type == "laptop";
in

{
	powerManagement =
	{
		enable = true;
		cpuFreqGovernor = if is-laptop then "powersave" else "performance";

		# Diagnose issues with power
		# Powertop makes the keyboard and mouse sleep after 5s
		powertop = lib.mkIf (is-laptop)
		{
			enable = lib.mkDefault true;
			postStart = ''
# [asus] Disable auto-sleep for external mouse and keyboard
echo 'on' > '/sys/bus/usb/devices/1-1/power/control';
echo 'on' > '/sys/bus/usb/devices/1-6/power/control';
echo 'on' > '/sys/bus/usb/devices/1-10/power/control';
'';
		};
	};

	services.logind.settings.Login =
	{
		HandleLidSwitch              = "lock";   # lid closed, monitor unavailable
		HandleLidSwitchDocked        = "ignore"; # lid closed, monitor available
		HandleLidSwitchExternalPower = "ignore"; # lid closed, monitor available, plugged in

		# TODO: lock or sleep?
		IdleAction = "lock";                    # sleep on idle
		IdleActionSec = "${toString (60 * 5)}"; # execute idle action after 5 minutes
	};


	# tweak to don't overheat cpu
	services.thermald.enable = lib.mkDefault true; # intel cpu only


	# Laptop only
	# ------------------------------------------------------------ #

	# laptop battery saving
	services.tlp.enable = lib.mkDefault (true && is-laptop);

	# provide dbus service
	services.upower = lib.mkIf (is-laptop)
	{
		enable = lib.mkDefault true;

		criticalPowerAction = "Suspend";
		allowRiskyCriticalPowerAction = true;

		percentageLow = 30;
		percentageCritical = 20;
		percentageAction = 10;
	};
}
