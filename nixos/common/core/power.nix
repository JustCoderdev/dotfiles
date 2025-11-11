{ pkgs, lib, settings, ... }:

let
	inherit (settings) hardware-type;

	is-laptop = hardware-type == "laptop";
in

{
	powerManagement =
	{
		enable = true;
		cpuFreqGovernor = if is-laptop then "powersave" else "performance";
		powertop.enable = true && is-laptop;
	};

	services.thermald.enable = true;
	services.logind =
	{
		lidSwitch = "lock";
		lidSwitchExternalPower = "lock";
		lidSwitchDocked = "lock";
	};

	# -------------------- # 

	services.upower = lib.mkIf (is-laptop)
	{
		enable = true;

		criticalPowerAction = "Suspend";
		allowRiskyCriticalPowerAction = true;

		percentageLow = 30;
		percentageCritical = 20;
		percentageAction = 10;
	};

	services.tlp = lib.mkIf (is-laptop)
	{
		enable = true;
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
