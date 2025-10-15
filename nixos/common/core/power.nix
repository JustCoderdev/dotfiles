{ ... }:

{
	powerManagement = {
		enable = true;
		cpuFreqGovernor = "performance";
		#powertop.enable = true;
	};


	# All options available here
	# <https://www.mankier.com/5/logind.conf>
	services.logind =
	{
		# "HandlePowerKey"          = "poweroff";
		# "HandlePowerKeyLongPress" = "ignore";

		# "HandleRebootKey"          = "reboot";
		# "HandleRebootKeyLongPress" = "poweroff";

		# "HandleSuspendKey"          = "suspend";
		# "HandleSuspendKeyLongPress" = "hibernate";

		# "HandleHibernateKey"          = "hibernate";
		# "HandleHibernateKeyLongPress" = "ignore";

		# "HandleLidSwitch"              = "suspend";
		# "HandleLidSwitchExternalPower" = "suspend";
		# "HandleLidSwitchDocked"        = "ignore";

		powerKey          = "lock";
		powerKeyLongPress = "poweroff";

		lidSwitch              = "lock";
		lidSwitchExternalPower = "lock";
		lidSwitchDocked        = "lock";

		extraConfig = ''
IdleAction=lock
IdleActionSec=120
'';
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
}
