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
# [asus] Disable auto-sleep for mouse and keyboard
echo 'on' > '/sys/bus/usb/devices/usb1/power/control';
echo 'on' > '/sys/bus/usb/devices/usb2/power/control';
'';
		};
	};

	services.thermald.enable = lib.mkDefault true;
	services.logind =
	{
		lidSwitch = "lock";
		lidSwitchExternalPower = "lock";
		lidSwitchDocked = "lock";
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
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave"; # "schedutil"
			CPU_SCALING_GOVERNOR_ON_AC = "performance";

			CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # "schedutil"
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

			CPU_MIN_PERF_ON_BAT = 0;
			CPU_MAX_PERF_ON_BAT = 20;

			CPU_MIN_PERF_ON_AC = 0;
			CPU_MAX_PERF_ON_AC = 100;

			START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
			STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
		};
	};
}
