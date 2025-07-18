{ config, settings, ... }:

{
	#Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.systemd-boot.configurationLimit = 5;
	boot.loader.efi.canTouchEfiVariables = true;

	#Virtualisation

	# Intel Graphics
	boot.initrd.kernelModules = [ "i915" ];

	# Nvidia support
	boot.kernelParams = [
		"nosgx"
		"snd-intel-dspcfg.dsp_driver=1"
	];

	hardware.nvidia = {
		modesetting.enable = true;

		# GPU Support for GeForce GTX 1050Ti
		package = config.boot.kernelPackages.nvidiaPackages.stable;

		# Enable this if you have graphical issues
		powerManagement.enable = false;

		# Works on modern Nvidia GPUs (Turing or newer)
		powerManagement.finegrained = false;

		# Use open source driver
		open = false;

		# Enable the Nvidia settings menu,
		nvidiaSettings = false;
	};


	#Mount
	fileSystems =
	{
		"/home/WDC_WD10" =
		{
			device = "/dev/disk/by-uuid/87de6ef7-b2ea-43ea-b574-52ca561288df";
			fsType = "ext4";
		};

		# -- IMPORTANT -- #
		"/nix" =
		{
			device = "/dev/disk/by-uuid/aa7d119a-8bdf-48e0-a3f4-76b3f71a6aac";
			fsType = "ext4";
			neededForBoot = true;
			options = [ "noatime" ];
		};
		# -- IMPORTANT -- #
	};

	systemd.tmpfiles.rules = let
		uname = settings.username;
		uhome = "/home/${uname}";
	in [
#		Type Path           Mode User     Group Age Argument
		"d   /home/WDC_WD10 0755 ${uname} users                   "
		"L+  /home/WDC_WD10 -    -        -     -   ${uhome}/HDisk"
	];
}
