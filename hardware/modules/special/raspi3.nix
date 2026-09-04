
  #############################
  #     !!! IMPORTANT !!!     #
  # IMPORT ONLY ON RASPBERRY3 #
  #############################

{ lib, modulesPath, ... }:

let
	nixos-hardware = fetchTarball {
		url = "https://github.com/NixOS/nixos-hardware/tarball/0ed819e708af17bfc4bbc63ee080ef308a24aa42";
		sha256 = "0n83riy6j6vlsjcsjp1w704ag5db8gyd3qap0ir4gl8ffanm4kr3";
	};
in

{
	imports =
	[
		"${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
		"${nixos-hardware}/raspberry-pi/3"
	];

	config =
	{
		# Disable unbuildable services
		services.printing.enable = lib.mkForce false;
		services.thermald.enable = lib.mkForce false;
		networking.networkmanager.plugins = lib.mkForce [ ];

		# Reduce memory usage
		boot.tmp.cleanOnBoot = true;
		swapDevices = [ { device = "/swapfile"; size = 1024; } ];

		# Tell the Nix evaluator to garbage collect more aggressively
		environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

		# Other
		hardware.enableRedistributableFirmware = true;
	};
}
