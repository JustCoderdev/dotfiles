{ config, lib, ... }:

let
	cfg = config.common.core.nvidia;
in

{
	config = lib.mkIf cfg.enable {
		services.xserver.videoDrivers = [ "nvidia" ];
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
	};
}
