{
	description = "NixOS System flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixd = {
			url = "github:nix-community/nixd";
			inputs.nixpkgs.follows = "nixpkgs";
		};

#		firefox-addons = {
#			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
#			inputs.nixpkgs.follows = "nixpkgs";
#		};

#		disko = {
#			url = "github:nix-community/disko/v1.11.0";
#			inputs.nixpkgs.follows = "nixpkgs";
#		};
	};
	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixd }@inputs:
		let
			_hostname = "quiss";
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

			path = settings.dotfiles_path;
			args = { inherit inputs pkgs-unstable settings; };
			modules = [
				(path + "/nixos/hosts/${settings.hostname}/hardware-configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/options.nix")
				(path + "/nixos/hosts/${settings.hostname}/configuration.nix")
				(path + "/nixos/hosts/${settings.hostname}/boot.nix")

				(path + "/nixos/profiles/configuration.nix")

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = args;
					#home-manager.backupFileExtension = "bak";
					home-manager.users.${settings.username} =
						import (path + "/nixos/profiles/home.nix");
				}
			];
#			++
#			(let diskopath = (path + "/nixos/hosts/${settings.hostname}/disko.nix"); in
#				nixpkgs.lib.optionals (nixpkgs.lib.pathExists diskopath) [
#					diskopath
#					disko.nixosModules.disko
#				]
#			);

			systemBuilder = nixpkgs.lib.nixosSystem {
				system = settings.system;
				specialArgs = args;
				inherit modules;
			};

			userBuilder = home-manager.lib.homeManagerConfiguration {
				extraSpecialArgs = args;
				modules = [ ./profiles/home.nix ];
				inherit pkgs;
			};
		in {

		# hostname
		nixosConfigurations = {
			quiss = systemBuilder;
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
