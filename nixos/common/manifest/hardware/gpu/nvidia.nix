{ config, lib, pkgs, settings, ... }:

let 
	cfg = config.common.manifest;

	self-manifest = cfg.self;
	self-ngpu = self-manifest.hardware.gpu.nvidia;

	self-icpu-data = self-manifest.hardware.cpu.intel;
	self-is-icpu = self-icpu-data.architecture != null;
	self-has-icpu-igpu = if self-is-icpu then self-icpu-data.has-iGPU else false;
in

{
	config = lib.mkIf (self-ngpu.architecture != null)
	{
		system.nixos.tags = [ "nvidia" ];

		/* ls /dev/dri - sudo dmesg | grep drm */
		boot.kernelParams = [ "nvidia-drm.fbdev=1" ]
		++ lib.optionals (self-is-icpu) [
			"nosgx"
			"snd-intel-dspcfg.dsp_driver=1"
		];

		services.xserver.videoDrivers = [ ]
		++ lib.optionals (
			self-manifest.hardware.graphics.capable && !self-has-icpu-igpu
		) [ "nvidia" ];

		hardware.nvidia =
		{
			modesetting.enable = true;
			package = config.boot.kernelPackages.nvidiaPackages.${self-ngpu.driver.name};
			open = false && self-ngpu.ge-turing; # Use open source driver (Turing or newer)

			nvidiaSettings = true;  # Enable the Nvidia settings menu,
			dynamicBoost.enable = true && self-has-icpu-igpu;
			prime = {
				offload.enable = self-ngpu.offload.enable;
				inherit (self-ngpu.offload) nvidiaBusId intelBusId;
			};

			powerManagement = {
				enable = false;  # saves gpu state to /tmp
				finegrained = self-ngpu.offload.enable && self-ngpu.ge-turing;  # gpu off when idle (Turing or newer)
			};
		};

		environment = {
			sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

			systemPackages = with pkgs; [ nvitop nvtopPackages.nvidia ] # radeontop for amd
				++ lib.optionals (!self-has-icpu-igpu) [ pkgs.libva-utils ];

			# VAAPI
			variables = lib.mkIf (!self-has-icpu-igpu) {
				NVD_BACKEND = "direct";
				LIBVA_DRIVER_NAME = "nvidia";
				MOZ_DISABLE_RDD_SANDBOX = "1"; # Firefox
			};
		};

		programs.firefox.preferences =
		let
			ffVersion = config.programs.firefox.package.version;
		in
			lib.mkIf (self-has-icpu-igpu) {
			"media.ffmpeg.vaapi.enabled" = lib.versionOlder ffVersion "137.0.0";
			"media.hardware-video-decoding.force-enabled" = lib.versionAtLeast ffVersion "137.0.0";
			"media.rdd-ffmpeg.enabled" = lib.versionOlder ffVersion "97.0.0";
			"media.av1.enabled" = self-ngpu.ge-turing;
			"gfx.x11-egl.force-enabled" = true;
			"widget.dmabuf.force-enabled" = true;
		};

		assertions =
		let
			add-assertion = (
				assertion: message:
				{ inherit assertion message; }
			);
		in
		(
			[
				(add-assertion (self-ngpu.driver-name != null) "The gpu specified in the manifest has no supported driver package")
			]
			++ lib.lists.optionals (self-ngpu.offload.enable)
			[
				(add-assertion (self-ngpu.offload.intelBusId != null)  "GPU offload is enabled but the intelBusId is not provided")
				(add-assertion (self-ngpu.offload.nvidiaBusId != null) "GPU offload is enabled but the nvidiaBusId is not provided")
			]
		);
	};
}
