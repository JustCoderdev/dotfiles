{ pkgs, settings, ... }:

let
	is-laptop = settings.hardware-type == "laptop";
in

{
	powerManagement = {
		enable = true;
		cpuFreqGovernor = if is-laptop then "powersave" else "performance";
		powertop.enable = true;
	};

	services =
	{
		thermald.enable = true;

		upower = {
			enable = is-laptop;

			criticalPowerAction = "Suspend";
			allowRiskyCriticalPowerAction = true;

			percentageLow = 30;
			percentageCritical = 20;
			percentageAction = 10;
		};

		tlp = {
			enable = true;
			settings = {
				CPU_SCALING_GOVERNOR_ON_BAT = if is-laptop then "powersave" else "schedutil";
				CPU_SCALING_GOVERNOR_ON_AC = "performance";

				CPU_ENERGY_PERF_POLICY_ON_BAT = if is-laptop then "power" else "schedutil";
				CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

				CPU_MIN_PERF_ON_BAT = 0;
				CPU_MAX_PERF_ON_BAT = if is-laptop then 20 else 100;

				CPU_MIN_PERF_ON_AC = 0;
				CPU_MAX_PERF_ON_AC = 100;
			};
		};

		logind = {
			lidSwitch = "lock";
			lidSwitchExternalPower = "lock";
			lidSwitchDocked = "lock";
		};
	};
}
