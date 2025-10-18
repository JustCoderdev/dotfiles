{ config, lib, pkgs, ... }:

let 
	cfg-hw = config.common.core.hardware;
	using-cpu-intel = cfg-hw.cpu.manufacturer == "intel";

	cfg-hardware-manifest = config.common.core.hardware-manifest;

	nvidia-archs = cfg-hardware-manifest.architectures.gpu.nvidia;

	ge-turing = nvidia-archs.turing.year >= nvidia-archs.${cfg-hw.gpu.architecture}.year;
	gt-turing = nvidia-archs.turing.year > nvidia-archs.${cfg-hw.gpu.architecture}.year;
in

{
	config = lib.mkIf (cfg-hw.gpu.manufacturer == "nvidia")
	{
		system.nixos.tags = [ "nvidia" ];

		/* ls /dev/dri - sudo dmesg | grep drm */
		boot.kernelParams = [ "nvidia-drm.fbdev=1" ]
		++ lib.optionals (using-cpu-intel) [
			"nosgx"
			"snd-intel-dspcfg.dsp_driver=1"
		];

		services.xserver.videoDrivers = [ ]
		++ lib.optionals (!cfg-hw.cpu.has-iGPU) [ "nvidia" ];

		hardware.nvidia =
		{
			modesetting.enable = true;
			package = nvidia-archs.${cfg-hw.gpu.architecture}.driver.pkg;

			powerManagement = {
				enable = false;  # saves gpu state to /tmp
				finegrained = cfg-hw.gpu.offload.enable && ge-turing;  # gpu off when idle (Turing or newer)
			};

			# Use open source driver (Turing or newer)
			open = false && ge-turing; 

			# Enable the Nvidia settings menu,
			nvidiaSettings = true;
			dynamicBoost.enable = true && cfg-hw.cpu.has-iGPU;

			# Offload
			prime = {
				offload.enable = cfg-hw.gpu.offload.enable;
				inherit (cfg-hw.gpu.offload) intelBusId nvidiaBusId;
			};
		};


		environment = {
			sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

			systemPackages = with pkgs; [ nvitop nvtopPackages.nvidia ] # radeontop for amd
				++ lib.optionals (!cfg-hw.cpu.has-iGPU) [ pkgs.libva-utils ];

			# VAAPI
			variables = lib.mkIf (!cfg-hw.cpu.has-iGPU) {
				NVD_BACKEND = "direct";
				LIBVA_DRIVER_NAME = "nvidia";
				MOZ_DISABLE_RDD_SANDBOX = "1"; # Firefox
			};
		};

		programs.firefox.preferences =
		let
			ffVersion = config.programs.firefox.package.version;
		in
			lib.mkIf (cfg-hw.cpu.has-iGPU) {
			"media.ffmpeg.vaapi.enabled" = lib.versionOlder ffVersion "137.0.0";
			"media.hardware-video-decoding.force-enabled" = lib.versionAtLeast ffVersion "137.0.0";
			"media.rdd-ffmpeg.enabled" = lib.versionOlder ffVersion "97.0.0";
			"media.av1.enabled" = gt-turing;
			"gfx.x11-egl.force-enabled" = true;
			"widget.dmabuf.force-enabled" = true;
		};

		assertions = [ ]
		++ lib.lists.optionals (cfg-hw.gpu.offload.enable) [
			{
				assertion = cfg-hw.gpu.offload.intelBusId != null;
				message = "GPU offload is enabled but the intelBusId is not provided";
			}
			{
				assertion = cfg-hw.gpu.offload.nvidiaBusId != null;
				message = "GPU offload is enabled but the nvidiaBusId is not provided";
			}
		];
	};
}
