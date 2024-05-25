{ description = "NixOS config flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-23.05";

		home-manager = {
			url = "github:nix-community/home-manager/release-23.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs:
		let
			settings = {
				hostname = "virtualmachine";
				profile = "personal";

				username = "ryuji";
				system = "x86_64-linux";
				dotfilespath = "/.dotfiles";
			};

			pkgs = nixpkgs.legacyPackages.${settings.system};
			modules = [
				./hosts/${settings.hostname}/hardware-configuration.nix
				./profiles/${settings.profile}/configuration.nix
				# inputs.home-manager.nixosModules.default
			];

			systemBuilder = nixpkgs.lib.nixosSystem {
				system = settings.system;
				specialArgs = { inherit settings; };
				inherit modules;
			};

			userBuilder = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = { inherit settings; };
				modules = ./profiles/${settings.profile}/home.nix;
			};
		in {

		# hostname
		nixosConfigurations = {
			virtualmachine = systemBuilder;
			acer = systemBuilder;
		};

		# profile
		homeConfigurations = {
			personal = userBuilder;
		};
	};
}
