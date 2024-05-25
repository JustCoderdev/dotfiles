{
	description = "NixOS config flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-23.05";

		home-manager = {
			url = "github:nix-community/home-manager/release-23.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ... }@args:
		let
			# Configuration Switcher
			host = "virtualmachine";
			profile = "personal";

			# Other
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {

		# hostname
		nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
			inherit system;
			modules = [
				./profiles/${profile}/configuration.nix
				./hosts/${host}/hardware-configuration.nix
			];
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
