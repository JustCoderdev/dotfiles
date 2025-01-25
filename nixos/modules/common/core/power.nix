{ ... }:

{
	powerManagement = {
		enable = true;
		cpuFreqGovernor = "performance";
		powertop.enable = true;
	};

	services.thermald.enable = true;
	services.tlp = {
		enable = true;
		settings = {
			CPU_SCALING_GOVERNOR_ON_AC = "performance";
			CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";  #powersave

			CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";  # power
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

			CPU_MIN_PERF_ON_AC = 0;
			CPU_MAX_PERF_ON_AC = 100; CPU_MIN_PERF_ON_BAT = 0;
			CPU_MAX_PERF_ON_BAT = 100;

			#Optional helps save long term battery health
#			START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
#			STOP_CHARGE_THRESH_BAT0 = 100; # 80 and above it stops charging
		};
	};
}
