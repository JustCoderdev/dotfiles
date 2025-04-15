{ lib, ... }:

{
	# Disable unbuildable services
	# -------------------- #

	services.printing.enable = lib.mkForce false;
	services.thermald.enable = lib.mkForce false;
	networking.networkmanager.plugins = lib.mkForce [ ];

	# -------------------- #

	# Other
	hardware.enableRedistributableFirmware = true;

	# Enable SSH in the boot process.
	systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];

	# Reduce memory usage
	boot.tmp.cleanOnBoot = true;
	documentation.nixos.enable = false;
	swapDevices = [ { device = "/swapfile"; size = 1024; } ];

	# Enable cross compilation
	nixpkgs.config.allowUnsupportedSystem = true;
}
