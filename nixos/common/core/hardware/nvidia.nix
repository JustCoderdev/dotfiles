{ config, lib, pkgs, ... }:

let 
	cfg-hw = config.common.core.hardware;
	using-cpu-intel = cfg-hw.cpu.manufacturer == "intel";

	nvidia-archs =
	let
		add-arch = year: driver-name:
		{
			inherit year;
			driver = config.boot.kernelPackages.nvidiaPackages.${driver-name};
		};
	in
	{
		# <https://en.wikipedia.org/wiki/List_of_eponyms_of_Nvidia_GPU_microarchitectures>
		fahrenheit =   (add-arch 1998 null);
		celsius =      (add-arch 1999 null);
		kelvin =       (add-arch 2001 null);
		rankine =      (add-arch 2003 null);
		curie =        (add-arch 2004 null);
		tesla =        (add-arch 2006 "legacy_340");
		fermi =        (add-arch 2010 "legacy_470");
		kepler =       (add-arch 2012 "legacy_470");
		maxwell =      (add-arch 2014 "stable");
		pascal =       (add-arch 2016 "stable");
		volta =        (add-arch 2017 "stable");
		turing =       (add-arch 2018 "stable");
		ampere =       (add-arch 2020 "stable");
		hopper =       (add-arch 2022 "stable");
		ada-lovelace = (add-arch 2022 "stable");
		blackwell =    (add-arch 2024 "stable");
		rubin =        (add-arch 2026 "stable");
		feynman =      (add-arch 2028 "stable");
	};
	ge-turing = nvidia-archs.turing.year >= nvidia-archs.${cfg-hw.gpu.architecture}.year;
in

{
	config = 
	{
		system.nixos.tags = [ "nvidia" ];

		/* ls /dev/dri - sudo dmesg | grep drm */
		boot.kernelParams = [ "nvidia-drm.fbdev=1" ]
		++ lib.optionals (using-cpu-intel) [
			"nosgx"
			"snd-intel-dspcfg.dsp_driver=1"
		];

		services.xserver.videoDrivers = [ "nvidia" ];
		environment = {
			sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
			systemPackages = with pkgs; [ nvitop ]; # radeontop for amd
		};

		hardware.nvidia =
		{
			modesetting.enable = true;
			package = nvidia-archs.${cfg-hw.gpu.architecture}.driver;

			powerManagement = {
				enable = false;  # saves gpu state to /tmp
				finegrained = false && ge-turing;  # gpu off when idle (Turing or newer)
			};

			# Use open source driver (Turing or newer)
			open = false && ge-turing; 

			# Enable the Nvidia settings menu,
			nvidiaSettings = false;
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.hardware.nvidia =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable nvidia hardware support";
			default = config.common.core.hardware.gpu.manufacturer == "nvidia";
			readonly = true;
		};
	};
}
