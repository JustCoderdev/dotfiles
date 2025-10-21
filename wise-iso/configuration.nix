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
			# devices = [ ];
			efiSupport = true;
			efiInstallAsRemovable = true;
		};

		services.openssh.enable = true;
		environment.systemPackages = with pkgs; [ vim git ];
		users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY+uqI9B48MnbNJzXlgvGSxHTuWdGy3bxMOD7UW0Dt7 ryuji@msi" ];

		nix = {
			distributedBuilds = true;
			buildMachines = [
				{
					hostName = "10.0.0.1"; # msi
					maxJobs = 6;
					systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
					supportedFeatures  = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
					speedFactor = 1;

					protocol = "ssh"; # ssh-ng
					publicHostKey = null; # The (base64-encoded) public host key of this builder
					sshKey = "/tmp/nix-builder-ssh-key"; # private key to use to authenticate with the build machine
					sshUser = "buildclient"; # username to log into the remote host
				}
				{
					hostName = "192.168.1.5"; # msi
					maxJobs = 6;
					systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
					supportedFeatures  = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
					speedFactor = 1;

					protocol = "ssh"; # ssh-ng
					publicHostKey = null; # The (base64-encoded) public host key of this builder
					sshKey = "/tmp/nix-builder-ssh-key"; # private key to use to authenticate with the build machine
					sshUser = "buildclient"; # username to log into the remote host
				}
			];
		};

		services.openssh.hostKeys = [ {
			type = "ed25519";
			comment = "root_buildclient@nixosanywhere";
			path = "/tmp/nix-builder-ssh-key";
		} ];

		programs.ssh.extraConfig = ''
Host 192.168.1.5
	User buildclient
	IdentitiesOnly yes
	IdentityFile "/tmp/nix-builder-ssh-key"

Host 10.0.0.1
	User buildclient
	IdentitiesOnly yes
	IdentityFile "/tmp/nix-builder-ssh-key"
'';

		system.stateVersion = "24.05";
	};
}
