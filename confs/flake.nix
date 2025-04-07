{
	description = "JC Home Configuration flake";

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-24.11";

		home-manager = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		stylix = {
			url = "github:danth/stylix/release-24.11";
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


	outputs = { self, nixpkgs, home-manager, stylix, nixd }@inputs:
	let
		wallpapers_path = ./.wallpapers;

		getArgs = (
			username:
			{
				inherit inputs wallpapers_path nixd;
				settings = import ./settings/${username}.nix;
				confs_path = ./.;
			}
		);

		homeConfiguration = (
			{ config, lib, ... }:
			let
				username = config.username;
				args = getArgs username;
			in
			{
				imports =
				[
					inputs.stylix.nixosModules.stylix
					./stylix/base.nix { stylix.module.wallpapers_path = args.wallpapers_path; }
					./stylix/nixos.nix

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = args;
						home-manager.users.${username} = (
							{ ... }:
							{
								imports = [
									./stylix/hm.nix
									./users/${username}.nix
								];
							}
						);
					}
				];

				# config = {
				# 	stylix.module = { inherit wallpapers_path; };
				# };

				options.username = lib.mkOption {
					type = lib.types.str;
					readOnly = true;
					description = "name of the user";
				};
			}
		);

		homeBuilder = (
			username: system:
			let
				args = getArgs username;
			in
			home-manager.lib.homeManagerConfiguration {
				extraSpecialArgs = args;
				pkgs = nixpkgsFor.${system};
				modules = [
					inputs.stylix.homeManagerModules.stylix
					./stylix/base.nix { stylix.module.wallpapers_path = args.wallpapers_path; }
					./stylix/hm.nix

					./users/${username}.nix

					# (
					# 	{ ... }:
					# 	{
					# 		config = {
					# 			stylix.module = { inherit wallpapers_path; };
					# 		};
					# 	}
					# )
				];
			}
		);

		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
		listAllSystems = nixpkgs.lib.lists.forEach supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
	in
	{
		nixosModules = {
			home = homeConfiguration;
		};

		homeConfigurations = { }
			// forAllSystems (system: { ryuji = homeBuilder "ryuji" system; });

		# nix build
		packages = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in {
				ryuji-activation = (homeBuilder "ryuji" system).activationPackage;
			    #ryuji-activation = self.homeConfigurations."${system}".ryuji.activationPackage;
				darnix-plymouth-theme = pkgs.callPackage ./plymouth/darnix { };
			}
		);
	};
}
