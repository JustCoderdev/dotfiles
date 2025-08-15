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

#		firefox-addons = {
#			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
					inherit has_de;
					wallpapers_path = ./.wallpapers;
					confs_path = ./.;
				};
			}
		);

		homeConfiguration = (
			{ config, lib, ... }:
			let
				cfg = config.jcconfs;
				args = (getArgs { inherit (cfg) username has_de; });

				wallpapers_path = args.settings.wallpapers_path;
			in
			{
				imports =
				[
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
								imports = [
									inputs.stylix.homeModules.stylix
									./stylix/base.nix { stylix.module = { inherit wallpapers_path; inherit (cfg) has_de; }; }
									./stylix/hm.nix
									./users/${cfg.username}.nix
								];
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
			{ username, system, has_de }:
			let
				args = getArgs { inherit username has_de; };
				wallpapers_path = args.settings.wallpapers_path;
			in
			home-manager.lib.homeManagerConfiguration {
				extraSpecialArgs = args;
				pkgs = nixpkgsFor.${system};
				modules = [
					inputs.stylix.homeModules.stylix
					./stylix/base.nix { stylix.module = { inherit wallpapers_path has_de; }; }
					./stylix/hm.nix

					./users/${username}.nix
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
		// forAllSystems (
			system:
			let username = "ryuji"; in
			{
				ryuji       = homeBuilder { inherit username system; has_de = true;  };
				ryuji-no-de = homeBuilder { inherit username system; has_de = false; };
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

				# ryuji-activation       = (homeBuilder "ryuji" system true).activationPackage;
				# ryuji-no-de-activation = (homeBuilder "ryuji" system false).activationPackage;

				darnix-plymouth-theme = pkgs.callPackage ./plymouth/darnix { };
			}
		);
	};
}
