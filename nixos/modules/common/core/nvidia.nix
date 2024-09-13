{ config, lib, ... }:

let
	cfg = config.common.core.nvidia;
in

{
	config = lib.mkIf cfg.enable {

		system.nixos.tags = [ "nvidia" ];
		services.xserver.videoDrivers = [ "nvidia" ];
		environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

		hardware.nvidia = {
			modesetting.enable = true;

			# GPU Support for GeForce GTX 1050Ti
			#package = config.boot.kernelPackages.nvidiaPackages.stable;

			# (installs 550)
			package = config.boot.kernelPackages.nvidiaPackages.production;

			# Enable this if you have graphical issues
			powerManagement.enable = false;

			# Works on modern Nvidia GPUs (Turing or newer)
			powerManagement.finegrained = false;

			# Use open source driver
			open = false;

			# Enable the Nvidia settings menu,
			nvidiaSettings = false;
		};
	};
}
