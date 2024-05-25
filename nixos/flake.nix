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
				system = "x86_64-linux";
			};

			pkgs = nixpkgs.legacyPackages.${settings.system};
			modules = [
				./hosts/${settings.hostname}/hardware-configuration.nix
				./profiles/${settings.profile}/configuration.nix
			];

			systemBuilder = nixpkgs.lib.nixosSystem {
				system = settings.system;
				specialArgs = { inherit settings; };
				extraSpecialArgs = { inherit inputs; };
				inherit modules;
			};
		in {

		# hostname
		nixosConfigurations = {
			virtualmachine = systemBuilder;
			acer = systemBuilder
		};

		# homeConfigurations = { # username
		# 	ryuji = home-manager.lib.homeManagerConfiguration {
		# 		inherit pkgs;
		# 		modules = [
		# 			./users/ryuji/home.nix
		# 		];
		# 	};
		# };
	};
}
