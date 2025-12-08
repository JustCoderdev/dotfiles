{ modulesPath, lib, pkgs, ... }:
{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
		(modulesPath + "/profiles/qemu-guest.nix")
		./disk-config.nix
	];

	config =
	{
		boot.loader.grub = {
			# no need to set devices, disko will add all devices that have a EF02 partition to the list already
			efiSupport = true;
			efiInstallAsRemovable = true;
		};

		services.openssh.enable = true;
		environment.systemPackages = with pkgs; [ vim git ];
		users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7 ryuji@msi" ];

		services.openssh.hostKeys = [ {
			type = "ed25519";
			comment = "root_buildclient@nixosanywhere";
			path = "/tmp/nix-builder-ssh-key";
		} ];

		system.stateVersion = "24.05";
	};
}
