{ pkgs, ... }:

{
	powerManagement = {
		enable = true;
		cpuFreqGovernor = "performance";
		#powertop.enable = true;
	};

	services =
	{
		thermald.enable = true;

		# upower = {
		# 	enable = true;
		# 	criticalPowerAction = "Suspend";
		# 	allowRiskyCriticalPowerAction = true;
		# };

		tlp = {
			enable = true;
			settings = {
				CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";      #powersave
				CPU_SCALING_GOVERNOR_ON_AC = "performance";

				CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";  # power
				CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

				CPU_MIN_PERF_ON_BAT = 0;
				CPU_MAX_PERF_ON_BAT = 100;

				CPU_MIN_PERF_ON_AC = 0;
				CPU_MAX_PERF_ON_AC = 100;
			};
		};
	};

	# Service template that I copied from gurkan, thanks <3
	# <https://git.gurkan.in/gurkan/nixos-config/src/branch/master/modules/laptop/services.nix>
	systemd.services = {
		# Do not restart these, since it fucks up the current session
		systemd-logind.restartIfChanged = false;
		polkit.restartIfChanged = false;
		display-manager.restartIfChanged = false;
		NetworkManager.restartIfChanged = false;
		wpa_supplicant.restartIfChanged = false;

		lock-before-sleeping = {
			restartIfChanged = false;

			unitConfig.Description = "Helper service to bind locker to sleep.target";
			serviceConfig = {
				ExecStart = "${pkgs.lightdm}/bin/dm-tool lock";
				Type = "simple";
			};
			before   = [ "pre-sleep.service" ];
			wantedBy = [ "pre-sleep.service" ];
			# environment = {
			# 	DISPLAY = ":0";
			# 	XAUTHORITY = "/home/gurkan/.Xauthority";
			# };
		};
	};
}
