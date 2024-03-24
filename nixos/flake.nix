{
	description = "NixOS System flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-23.05";

		home-manager = {
			url = "github:nix-community/home-manager/release-23.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs:
		let
			settings = rec {
				hostname = "virtualmachine";
				profile = "personal";
				username = "ryuji";

				dotfiles_path = ./..;
				dotfiles_abspath = "/.dotfiles";
				cache_path = "~/.config";

				system = "x86_64-linux";
			};

			pkgs = nixpkgs.legacyPackages.${settings.system};
			modules = [
				./hosts/${settings.hostname}/hardware-configuration.nix
				./profiles/${settings.profile}/configuration.nix
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.${settings.username} = import ./profiles/${settings.profile}/home.nix;
					home-manager.extraSpecialArgs = { inherit settings; };
				}
			];

			systemBuilder = nixpkgs.lib.nixosSystem {
				system = settings.system;
				specialArgs = { inherit settings; };
				inherit modules;
			};

			# userBuilder = home-manager.lib.homeManagerConfiguration {
			# 	inherit pkgs;
			# 	extraSpecialArgs = { inherit settings; };
			# 	modules = ./profiles/${settings.profile}/home.nix;
			# };
		in {

		# hostname
		nixosConfigurations = {
			virtualmachine = systemBuilder;
			acer = systemBuilder;
		};

		# profile
		# homeConfigurations = {
		# 	# ${settings.username} = userBuilder;
		# 	personal = home-manager.lib.homeManagerConfiguration {
		# 		inherit pkgs;
		# 		extraSpecialArgs = { inherit settings; };
		# 		modules = ./profiles/${settings.profile}/home.nix;
		# 	};
        #
		# 	${settings.username} = home-manager.lib.homeManagerConfiguration {
		# 		inherit pkgs;
		# 		extraSpecialArgs = { inherit settings; };
		# 		modules = ./profiles/${settings.profile}/home.nix;
		# 	};
		# };
	};
}
