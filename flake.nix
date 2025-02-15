{
	description = "JC NixOS System flake";

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		jcbin = {
			url = "path:./bin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

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

	outputs = { self, nixpkgs, jcbin, nixpkgs-unstable, home-manager, nixd }@inputs:
		let
			_hostname = "msi";
			settings = import ./nixos/hosts/${_hostname}/settings.nix;
			dotfiles_path = ./.;

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

			args = { inherit inputs settings dotfiles_path pkgs-unstable; };
			modules = [
				./nixos/hosts/${settings.hostname}/hardware-configuration.nix
				./nixos/hosts/${settings.hostname}/options.nix
				./nixos/hosts/${settings.hostname}/configuration.nix
				./nixos/hosts/${settings.hostname}/boot.nix

				./nixos/profiles/configuration.nix

				jcbin.nixosModules.rebuild-system
				jcbin.nixosModules.backlight

				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = args;
					home-manager.users.${settings.username} =
						import ./nixos/profiles/home.nix;
				}
			];
#			++
#			(let diskopath = "./nixos/hosts/${settings.hostname}/disko.nix"; in
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
				modules = [ ./nixos/profiles/home.nix ];
				inherit pkgs;
			};
		in {

		# hostname
		nixosConfigurations = {
			msi = systemBuilder;
			virtualmachine = systemBuilder;
			acer = systemBuilder;
			quiss = systemBuilder;
		};

		# username
		homeConfigurations = {
			${settings.username} = userBuilder;
		};

		packages.${settings.system}.${settings.username} =
			self.homeConfigurations.${settings.username}.activationPackage;

		# nix develop
		devShell.${settings.system}.default = pkgs.mkShell {
			shellHook = ''
				PROMPT=$'%F{8} %~ %B%F{6}$%f%b ' zsh && exit
			'';

			# Run time
			buildInputs = with pkgs; [ git vim ];
		};
	};
}
