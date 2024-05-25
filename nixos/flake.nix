{
	description = "NixOS System flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-23.05";
#nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager/release-23.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

#nixd.url = "github:nix-community/nixd";
	};
#nixpkgs-unstable, , nixd
	outputs = { self, nixpkgs, home-manager }@inputs:
		let
			_hostname = "acer";
			settings = import ./hosts/${_hostname}/settings.nix;

#			pkgs-unstable = import inputs.nixpkgs-unstable {
#				system = settings.system;
#			};
			modules = let path = settings.dotfiles_path; in [
#				{
#					nixpkgs-unstable.overlays = [ nixd.overlays.default ];
#					environment.systemPackages = [ pkgs-unstable.nixd ];
#				}

				(path + "/nixos/hosts/${settings.hostname}/hardware-configuration.nix")
#					(path + "/nixos/hosts/${settings.hostname}/configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/boot.nix")

				(path + "/nixos/profiles/${settings.profile}/configuration.nix")

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = { inherit settings; };
					home-manager.users.${settings.username} =
						import (path + "/nixos/profiles/${settings.profile}/home.nix");
				}
			];

			systemBuilder = nixpkgs.lib.nixosSystem {
				system = settings.system;
				specialArgs = { inherit inputs settings; };
				inherit modules;
			};

			# userBuilder = home-manager.lib.homeManagerConfiguration {
			#	inherit legacy-pkgs;
			#	extraSpecialArgs = { inherit settings; };
			#	modules = [ ./profiles/${settings.profile}/home.nix ];
			# };
		in {

		# hostname
		nixosConfigurations = {
			nixos = systemBuilder;

			virtualmachine = systemBuilder;
			acer = systemBuilder;
		};

		# profile
		# homeConfigurations = {
		#	${settings.username} = userBuilder;
		# };
	};
}
