{ config, lib, pkgs, ... }:

let
	cfg = config.common.core.nvidia;
in

{
	config = lib.mkIf cfg.enable
	{
		system.nixos.tags = [ "nvidia" ];

		/* ls /dev/dri - dmesg | grep drm */
		boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

		services.xserver.videoDrivers = [ "nvidia" ];
		environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

		environment.systemPackages = with pkgs; [ nvitop ]; # radeontop for amd
		hardware.nvidia = {
			# Configure for each host in boot.nix
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.nvidia = 
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable nvidia support";
			default = false;
		};
	};
}
