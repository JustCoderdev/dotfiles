{ config, lib, pkgs, settings, jc-lib, ... }:

let
	cfg = config.common.core.hardware;
	using-cpu-intel = cfg.cpu.manufacturer == "intel";
	using-gpu-nvidia = cfg.gpu.manufacturer == "nvidia";
	using-gpu-amd = cfg.gpu.manufacturer == "amd";
in

{
	imports = [ ./nvidia.nix ./radeon.nix ] 
		++ lib.optionals (settings.is-raspi3 == true) [ ./raspi3.nix ];

	config =
	{
		hardware.graphics = {
			enable = true;
			enable32Bit = (settings.system == "x86_64-linux");
		};


		# -- CPU INTEL -- #

		boot.initrd.kernelModules = []
			++ lib.optionals (using-cpu-intel) [ "i915" ];
	};

	# ------------------------------------------------------------ #

	options.common.core.hardware = 
	{
		cpu = {
			manufacturer = jc-lib.mkNullOrEnumOption "CPU manufacturer" [ "intel" "amd" ];
			architecture = jc-lib.mkNullOrStrOption "CPU architecture";
			has-iGPU = lib.mkEnableOption "Has integrated gpu (for laptops)";
		};

		gpu = {
			manufacturer = jc-lib.mkNullOrEnumOption "GPU manufacturer" [ "intel" "amd" "nvidia" ];
			architecture = jc-lib.mkNullOrStrOption "GPU architecture";
			offload = {
				enable = lib.mkOption {
					description = "Whether to enable gpu offload";
					type = lib.types.bool;
					default = cfg.cpu.has-iGPU;
				};
				intelBusId = jc-lib.mkNullOrStrOption "Intel bus id";
				nvidiaBusId = jc-lib.mkNullOrStrOption "Nvidia bus id";
			};
		};

		displays = jc-lib.mkSubmodOption "All displays connected to device" (
			{
				options = {
					identifier = jc-lib.mkStrOptionWexample "The identifier of the display given by `xrandr -q`" "DP-0";
					resolution = jc-lib.mkStrOptionWexample "The resolution of the display" "1920x1080";
					position = jc-lib.mkStrOptionWexample "The position relative to other displays" "1920x0";
				};
			}
		);
	};
}

