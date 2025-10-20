{ config, lib, pkgs, settings, ... }:

let
	cfg = config.common.manifest;
	self-manifest = cfg.self;

	radeon-archs = cfg.architectures.gpu.radeon;
	self-rgpu = self-manifest.hardware.gpu.radeon;
in

{
	config = lib.mkIf (self-rgpu.architecture != null)
	{
		system.nixos.tags = [ "radeon" ];

		boot.initrd.kernelModules = [ "amdgpu" ];
		boot.kernelParams = []
		++ lib.optionals (self-rgpu.architecture == "gcn1")
			[ "radeon.si_support=0" "amdgpu.si_support=1" ]
		++ lib.optionals (self-rgpu.architecture == "gcn2")
			[ "radeon.cik_support=0" "amdgpu.cik_support=1" ];

		services.xserver.videoDrivers = [ ]
		++ lib.optionals (self-manifest.hardware.graphics.capable) [ "amdgpu" ];

		# gcn > 3
		# Source <https://nixos.wiki/wiki/AMD_GPU>
		#systemd.tmpfiles.rules = [
##			Type Path          Mode User Group Age Argument
		#	"L+  /opt/rocm/hip -    -    -     -   ${pkgs.rocmPackages.clr}"
		#];

		environment.systemPackages = with pkgs; [ radeontop clinfo ]; 

		hardware.graphics = {
			extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
			extraPackages = with pkgs; [ amdvlk ]
				++ lib.optionals (self-rgpu.architecture == "gcn1") [ mesa.opencl ]
				++ lib.optionals (self-rgpu.architecture != "gcn1") [ rocmPackages.clr.icd ];
		};
	};
}
