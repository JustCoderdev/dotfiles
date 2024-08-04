{
	description = "NixOS System flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.05";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixd.url = "github:nix-community/nixd";

#		firefox-addons = {
#			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
#			inputs.nixpkgs.follows = "nixpkgs";
#		};
	};
	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixd }@inputs:
		let
			_hostname = "msi";
			settings = import ./hosts/${_hostname}/settings.nix;

			pkgs = nixpkgs.legacyPackages.${settings.system};
			pkgs-unstable = import nixpkgs-unstable {
				system = settings.system;
				overlays = [ nixd.overlays.default ];
				config = let pkgs = settings.special_pkgs; in {
					permittedInsecurePackages = pkgs.insecure;
					allowUnfreePredicate = pkg: builtins.elem
						(nixpkgs.lib.getName pkg) pkgs.unfree;
				};
			};

			args = { inherit inputs pkgs-unstable settings; };
			modules = let path = settings.dotfiles_path; in [
				(path + "/nixos/hosts/${settings.hostname}/hardware-configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/boot.nix")

				(path + "/nixos/profiles/${settings.profile}/configuration.nix")

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = args;
					home-manager.backupFileExtension = "bak";
					home-manager.users.${settings.username} =
						import (path + "/nixos/profiles/${settings.profile}/home.nix");

				}
			];

			systemBuilder = nixpkgs.lib.nixosSystem {
				system = settings.system;
				specialArgs = args;
				inherit modules;
			};

			userBuilder = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = args;
				modules = [ ./profiles/${settings.profile}/home.nix ];
			};
		in {

		# hostname
		nixosConfigurations = {
			nixos = systemBuilder;

			msi = systemBuilder;
			virtualmachine = systemBuilder;
			acer = systemBuilder;
		};

		# profile
		homeConfigurations = {
			${settings.username} = userBuilder;
		};

		packages.${settings.system}.${settings.username} =
			self.homeConfigurations.${settings.username}.activationPackage;

		#devShells.${settings.system} = let path = settings.dotfiles_path; in
		#	import (path + "/nixos/modules/system/dev/shells") { inherit pkgs; };
	};
}
