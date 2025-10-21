{
	description = "Wise server remote installer";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.05";

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, disko, ... }:
	{
		nixosConfigurations = 
		{
			wise = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					disko.nixosModules.disko
					./configuration.nix
					./hardware-configuration.nix
				];
			};
		};

		# tested with 2GB/2CPU droplet, 1GB droplets do not have enough RAM for kexec
		# nixosConfigurations.digitalocean = nixpkgs.lib.nixosSystem {
		# 	system = "x86_64-linux";
		# 	modules = [
		# 		./digitalocean.nix
		# 		disko.nixosModules.disko
		# 		{ disko.devices.disk.disk1.device = "/dev/vda"; }
		# 		./configuration.nix
		# 	];
		# };

		# Use this for all other targets
		# nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
		# nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
		# 	system = "x86_64-linux";
		# 	modules = [
		# 		disko.nixosModules.disko
		# 		./configuration.nix
		# 		./hardware-configuration.nix
		# 	];
		# };
	};
}
