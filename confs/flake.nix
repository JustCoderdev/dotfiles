{
	description = "JC Home Configuration flake";

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-24.11";

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
	};


	outputs = { self, nixpkgs, home-manager, nixd }@inputs:
	let
		getArgs = (
			username:
			{
				inherit inputs nixd;
				settings = import ../settings/users/${username}.nix;
			}
		);

		homeConfiguration = (
			username: special_pkgs:
			{
				imports = [
					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = getArgs username;
						home-manager.users.${username} = import ./users/${username}.nix;
					}
				];
			}
		);

		homeBuilder = (
			username: system:
			home-manager.lib.homeManagerConfiguration {
				extraSpecialArgs = getArgs username;
				modules = [ ./users/${username}.nix ];
				pkgs = nixpkgs.legacyPackages.${system};
			}
		);

		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
	in
	{
		nixosModules = {
			home = homeConfiguration;
		};

		homeConfigurations = {
			ryuji = homeBuilder "ryuji" "x86_64";
		};

		# nix build
		packages = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in {
				ryuji-activation = (homeBuilder "ryuji" system).activationPackage;
				# ryuji-activation = self.homeConfigurations.ryuji.activationPackage;
				darnix-plymouth-theme = pkgs.callPackage ./plymouth/darnix { };
			}
		);
	};
}
