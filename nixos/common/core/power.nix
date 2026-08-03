{ config, lib, ... }:

let
	is-laptop = config.common.manifest.self.hardware.type == "laptop";
in

{
	powerManagement =
	{
		enable = true;
		cpuFreqGovernor = if is-laptop then "powersave" else "performance";

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

	services.thermald.enable = lib.mkDefault true;

	services.logind.settings.Login =
	{
		HandleLidSwitch              = "lock";   # lid closed, monitor unavailable
		HandleLidSwitchDocked        = "ignore"; # lid closed, monitor available
		HandleLidSwitchExternalPower = "ignore"; # lid closed, monitor available, plugged in

		# TODO: lock or sleep?
		IdleAction = "lock";                    # sleep on idle
		IdleActionSec = "${toString (60 * 5)}"; # execute idle action after 5 minutes
	};

	# -------------------- #

	services.upower = lib.mkIf (is-laptop)
	{
		enable = lib.mkDefault true;

		criticalPowerAction = "Suspend";
		allowRiskyCriticalPowerAction = true;

		percentageLow = 30;
		percentageCritical = 20;
		percentageAction = 10;
	};

	services.tlp = lib.mkIf (is-laptop)
	{
		enable = lib.mkDefault true;
		settings =
		{
			# performance, balance_performance, default, balance_power, power
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
			CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";

			CPU_MIN_PERF_ON_BAT = 0;
			CPU_MAX_PERF_ON_BAT = 20;

			CPU_MIN_PERF_ON_AC = 0;
			CPU_MAX_PERF_ON_AC = 100;

			CPU_BOOST_ON_AC = 1;
			CPU_BOOST_ON_BAT = 0;

			START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
			STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
		};
	};
}
