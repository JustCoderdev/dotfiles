{
	description = "Wise server remote installer";

	inputs =
	{
		nixpkgs.url = "nixpkgs/nixos-25.05";

		disko.url = "github:nix-community/disko";
		disko.inputs.nixpkgs.follows = "nixpkgs";
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
	};
}
