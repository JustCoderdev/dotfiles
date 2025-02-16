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
		_username = "ryuji";
		dotfiles_path = "/.dotfiles";
		settings = import ../settings/${_username}.nix;

		pkgs = nixpkgs.legacyPackages.${system};
		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

		args = { inherit inputs settings dotfiles_path; };
		homeConfiguration = (
			username: home-manager.nixosModules.home-manager {
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.extraSpecialArgs = args;
				home-manager.users.${username} = import ./${username}.nix;
			}
		);

		homeBuilder = (
			username: home-manager.lib.homeManagerConfiguration {
				extraSpecialArgs = args;
				modules = [ import ./${username}.nix ];
				inherit pkgs;
			}
		);
	in
	{
		nixosModules.${_username} = homeConfiguration _username;

		# home-manager 
		homeConfigurations.${_username} = homeBuilder _username;

		# nix build
		packages.${_username} = forAllSystems (system:
			self.homeConfigurations.${_username}.activationPackage
		);
	};
}
