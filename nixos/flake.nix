{
	description = "NixOS System flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

#		hyprland = {
#			url = "github:hyprwm/Hyprland";
#			inputs.nixpkgs.follows = "nixpkgs";
#		};

		nixd.url = "github:nix-community/nixd";
	};
	outputs = { self, nixpkgs, home-manager, nixd }@inputs:
		let
			_hostname = "acer";
			settings = import ./hosts/${_hostname}/settings.nix;

			pkgs = nixpkgs.legacyPackages.${settings.system};

			args = { inherit inputs settings; };
			modules = let path = settings.dotfiles_path; in [
				(path + "/nixos/hosts/${settings.hostname}/hardware-configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/boot.nix")

				(path + "/nixos/profiles/${settings.profile}/configuration.nix")

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = args;
					home-manager.users.${settings.username} =
						import (path + "/nixos/profiles/${settings.profile}/home.nix");
				}
			];

			systemBuilder = nixpkgs.lib.nixosSystem {
				system = settings.system;
				specialArgs = args;
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

		#devShells.${settings.system} = let path = settings.dotfiles_path; in
		#	import (path + "/nixos/modules/system/dev/shells") { inherit pkgs; };
	};
}
