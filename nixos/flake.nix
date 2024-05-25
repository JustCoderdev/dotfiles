{
	description = "NixOS System flake";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-23.05";

		home-manager = {
			url = "github:nix-community/home-manager/release-23.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager }@inputs:
		let
			# User settings
			settings = rec {
				hostname = "virtualmachine";
				profile = "personal";
				username = "ryuji";

				dotfiles_path = ./..;
				dotfiles_abspath = "/.dotfiles";
				config_path = "/home/${username}/.config";
				cache_path = "/home/${username}/.cache";

				system = "x86_64-linux";
				special_pkgs = {
					unfree = [ "obsidian" ];
					insecure = [ "electron-24.8.6" ];
				};
			};

			## Auto install script stuff ##
			# supportedSystems = [ "i686-linux" "x86_64-linux" ];
			# forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
			# nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });

			# Other
			legacy-pkgs = nixpkgs.legacyPackages.${settings.system};
			args = { inherit settings; };  # inherit nixd; };
			modules = [
				# {
				# 	nixpkgs.overlays = [ nixd.overlays.default ];
				# 	environment.systemPackages = [ pkgs.nixd ];
				# }
				(settings.dotfiles_path + "/nixos/hosts/${settings.hostname}/hardware-configuration.nix")
				(settings.dotfiles_path + "/nixos/hosts/${settings.hostname}/boot.nix")
				(settings.dotfiles_path + "/nixos/profiles/${settings.profile}/configuration.nix")

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = args;
					home-manager.users.${settings.username} =
						import (settings.dotfiles_path + "/nixos/profiles/${settings.profile}/home.nix");
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

		## Auto install script stuff ##
		# packages = forAllSystems (system: let pkgs = nixpkgsFor.${system}; in {
		# 	default = self.packages.${system}.install;
		#
		# 	install = pkgs.writeShellApplication {
		# 	name = "install";
		# 	runtimeInputs = with pkgs; [ git ]; # I could make this fancier by adding other deps
		# 	text = ''${./install.sh} "$@"'';
		# 	};
		# });

		## Auto install script stuff ##
		# apps = forAllSystems (system: {
		# 	default = self.apps.${system}.install;
		#
		# 	install = {
		# 		type = "app";
		# 		program = "${self.packages.${system}.install}/bin/install";
		# 	};
		# });
	};
}
