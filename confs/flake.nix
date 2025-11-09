{
	description = "JC Home Configuration flake";

	inputs =
	{
		nixpkgs.url = "nixpkgs/nixos-25.05";

		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		stylix = {
			url = "github:danth/stylix/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, stylix }@inputs:
	let
		users = [ "ryuji" "nixos" ];

		getArgs = (
			{ username, has-de, is-laptop }@configs:
			{
				inherit inputs;
				settings = (import ./settings/${username}.nix)
				// (configs)
				// {
					wallpapers_path = ./.wallpapers;
					confs_path = ./.;
				};
			}
		);

		getModules = (
			settings:
			[
				inputs.stylix.homeModules.stylix
				./stylix/base.nix { stylix.module = { inherit (settings) wallpapers_path has-de; }; }
				./stylix/hm.nix

				./default.nix
			]
		);

		homeConfiguration = (
			{ config, lib, ... }:
			let
				args = (getArgs { inherit (config.jcconfs) username has-de is-laptop; });
				inherit (args) settings;
				stylix-module-args = { inherit (args.settings) has-de wallpapers_path; };
			in
			{
				imports =
				[
					inputs.stylix.nixosModules.stylix
					./stylix/base.nix { stylix.module = stylix-module-args; }
					./stylix/nixos.nix

					home-manager.nixosModules.home-manager
					{
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = args;
						home-manager.users.${settings.username} = (
							{ ... }:
							{
								imports = (getModules settings);

								stylix.enable = true && settings.has-de;
								stylix.module = stylix-module-args;
							}
						);
					}
				];

				# ------------------------------------------------------------ #

				options.jcconfs =
				{
					username = lib.mkOption {
						description = "Name of the primary user";
						type = lib.types.str;
					};
					has-de = lib.mkEnableOption "graphical applications or not";
					is-laptop = lib.mkEnableOption "laptop specific modules";
				};
			}
		);

		homeBuilder = (
			{ username, has-de, is-laptop, pkgs }:
			let
				args = getArgs { inherit username has-de is-laptop; };
			in
			home-manager.lib.homeManagerConfiguration {
				extraSpecialArgs = args;
				modules = (getModules args.settings);
				inherit pkgs;
			}
		);

		optionalString = (cond: str: if cond then str else "");
		get-flags =
		(
			{ has-de, is-laptop }:
			""
			+ optionalString (has-de)    "-de"
			+ optionalString (is-laptop) "-lp"
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
				map-user =
				(
					username: { has-de, is-laptop }@flags:
					{
						name = "${username}${get-flags flags}";
						value = homeBuilder { inherit username has-de is-laptop; pkgs = nixpkgsFor.${system}; };
					}
				);
			in
			(
				builtins.listToAttrs
				(
					(builtins.map    (username: map-user username { has-de = false; is-laptop = false; }) users)
					++ (builtins.map (username: map-user username { has-de = true;  is-laptop = false; }) users)
					++ (builtins.map (username: map-user username { has-de = false; is-laptop = true;  }) users)
					++ (builtins.map (username: map-user username { has-de = true;  is-laptop = true;  }) users)
				)
			)
		);

		# nix build
		packages = forAllSystems
		(
			system:
			{
				darnix-plymouth-theme = nixpkgsFor.${system}.callPackage ./plymouth/darnix { };
			}
			//
			(
				let
					map-user =
					(
						username: { has-de, is-laptop }@flags:
						let
							conf-name = "${username}${get-flags flags}";
						in
						{
							name = "activate-${conf-name}";
							value = self.homeConfigurations."${system}"."${conf-name}".activationPackage;
						}
					);
				in
				builtins.listToAttrs
				(
					(builtins.map    (username: map-user username { has-de = false; is-laptop = false; }) users)
					++ (builtins.map (username: map-user username { has-de = true;  is-laptop = false; }) users)
					++ (builtins.map (username: map-user username { has-de = false; is-laptop = true;  }) users)
					++ (builtins.map (username: map-user username { has-de = true;  is-laptop = true;  }) users)
				)
			)
		);
	};
}
