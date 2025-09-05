{ config, lib, pkgs, ... }:

let
	cfg-hw = config.common.core.hardware;
in

{
	config = lib.mkIf (cfg-hw.gpu.manufacturer == "amd")
	{
		system.nixos.tags = [ "radeon" ];

		boot.initrd.kernelModules = [ "amdgpu" ];
		services.xserver.videoDrivers = [ "amdgpu" ];
		
		boot.kernelParams = []
		++ lib.optionals (cfg-hw.gpu.architecture == "gcn1")
		[
			"radeon.si_support=0" "amdgpu.si_support=1"
		]
		++ lib.optionals (cfg-hw.gpu.architecture == "gcn2")
		[
			"radeon.cik_support=0" "amdgpu.cik_support=1"
		];
	

		# gcn > 3
		# Source <https://nixos.wiki/wiki/AMD_GPU>
		#systemd.tmpfiles.rules = [
##			Type Path          Mode User Group Age Argument
		#	"L+  /opt/rocm/hip -    -    -     -   ${pkgs.rocmPackages.clr}"
		#];

		environment.systemPackages = with pkgs; [ radeontop clinfo ]; 

		hardware.graphics = {
			enable = true;      # Enable Vulkan
			enable32Bit = true; # Enable Vulkan for 32-bit
			extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
			extraPackages = with pkgs; [ amdvlk ]
			++ lib.optionals (cfg-hw.gpu.architecture == "gcn1") [ mesa.opencl ]
			++ lib.optionals (cfg-hw.gpu.architecture != "gcn1") [ rocmPackages.clr.icd ];
		};
	};
}
