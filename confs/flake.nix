{
	description = "JC Home Configuration flake";

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-25.05";

		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		stylix = {
			url = "github:danth/stylix/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

#		nixd = {
#			url = "github:nix-community/nixd";
#			inputs.nixpkgs.follows = "nixpkgs";
#		};
	};


	outputs = { self, nixpkgs, home-manager, stylix }@inputs:
	let
		getArgs = (
			{ username, has_de }:
			{
				inherit inputs;
				settings = (import ./settings/${username}.nix)
				// {
					inherit username has_de;
					wallpapers_path = ./.wallpapers;
					confs_path = ./.;
				};
			}
		);

		getModules = (
			settings:
			[
				inputs.stylix.homeModules.stylix
				./stylix/base.nix { stylix.module = { inherit (settings) wallpapers_path has_de; }; }
				./stylix/hm.nix

				./default.nix
			]
		);

		homeConfiguration = (
			{ config, lib, ... }:
			let
				cfg = config.jcconfs;
				args = (getArgs { inherit (cfg) username has_de; });
				wallpapers_path = args.settings.wallpapers_path;
			in
			{
				imports = [
					inputs.stylix.nixosModules.stylix
					./stylix/base.nix { stylix.module = { inherit wallpapers_path; inherit (cfg) has_de; }; }
					./stylix/nixos.nix

					home-manager.nixosModules.home-manager
					{
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = args;
						home-manager.users.${cfg.username} = (
							{ ... }:
							{
								imports = (getModules args.settings);

								stylix.enable = true && cfg.has_de;
								stylix.module = {
									inherit wallpapers_path;
									inherit (cfg) has_de;
								};
							}
						);
					}
				];

				# ------------------------------------------------------------ #

				options.jcconfs =
				{
					username = lib.mkOption {
						type = lib.types.str;
						readOnly = true;
						description = "Name of the primary user";
					};
					has_de = lib.mkEnableOption "Whether to enable graphical applications or not";
				};
			}
		);

		homeBuilder = (
			{ username, has_de, pkgs }:
			let
				args = getArgs { inherit username has_de; };
			in
			home-manager.lib.homeManagerConfiguration {
				extraSpecialArgs = args;
				modules = (getModules args.settings);
				inherit pkgs;
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
		// forAllSystems (
			system:
			let
				pkgs = nixpkgsFor.${system};
			in
			{
				ryuji       = homeBuilder { inherit pkgs; username = "ryuji"; has_de = true;  };
				ryuji-no-de = homeBuilder { inherit pkgs; username = "ryuji"; has_de = false; };

				nixos       = homeBuilder { inherit pkgs; username = "nixos"; has_de = true;  };
				nixos-no-de = homeBuilder { inherit pkgs; username = "nixos"; has_de = false; };
			}
		);

		# nix build
		packages = forAllSystems
		(
			system:
			let pkgs = nixpkgsFor.${system}; in
			{
				ryuji-activation       = self.homeConfigurations."${system}".ryuji.activationPackage;
				ryuji-activation-no-de = self.homeConfigurations."${system}".ryuji-no-de.activationPackage;

				nixos-activation       = self.homeConfigurations."${system}".nixos.activationPackage;
				nixos-activation-no-de = self.homeConfigurations."${system}".nixos-no-de.activationPackage;

				# ryuji-activation       = (homeBuilder "ryuji" system true).activationPackage;
				# ryuji-no-de-activation = (homeBuilder "ryuji" system false).activationPackage;

				darnix-plymouth-theme = pkgs.callPackage ./plymouth/darnix { };
			}
		);
	};
}
