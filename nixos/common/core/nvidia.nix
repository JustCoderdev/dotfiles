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
			# Configure for each host in boot.nix
		};
	};
}
