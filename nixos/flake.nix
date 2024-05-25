{
	description = "NixOS System flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-23.05";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager/release-23.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixd.url = "github:nix-community/nixd";
	};
	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixd }@inputs:
		let
			_hostname = "acer";
			settings = import ./hosts/${_hostname}/settings.nix;

			pkgs-unstable = import nixpkgs-unstable {
				system = settings.system;
				overlays = [ nixd.overlays.default ];
				config = let pkgs = settings.special_pkgs; in {
					permittedInsecurePackages = pkgs.insecure;
					allowUnfreePredicate = pkg: builtins.elem
						(nixpkgs.lib.getName pkg) pkgs.unfree;
				};
			};
			modules = let path = settings.dotfiles_path; in [
				(path + "/nixos/hosts/${settings.hostname}/hardware-configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/boot.nix")

				(path + "/nixos/profiles/${settings.profile}/configuration.nix")

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = { inherit pkgs-unstable settings; };
					home-manager.users.${settings.username} =
						import (path + "/nixos/profiles/${settings.profile}/home.nix");
				}
			];

			systemBuilder = nixpkgs.lib.nixosSystem {
				system = settings.system;
				specialArgs = { inherit inputs pkgs-unstable settings; };
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

		devShells = let path = settings.dotfiles_path; in
			(import (path + "/nixos/modules/system/dev/shells") { inherit inputs; });

		# profile
		# homeConfigurations = {
		#	${settings.username} = userBuilder;
		# };
	};
}
