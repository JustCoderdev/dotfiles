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
		nx-users = [ "ryuji" "school" ];
		hm-users = [ "nixos" ] ++ nx-users;

		getArgs = (
			{ username, has-de, is-laptop }@configs:
			{
				inherit inputs;
				settings = { }
				// (import ./settings/${username}.nix)
				// ({ inherit has-de is-laptop; })
				;
			}
		);

		getCommonModules =
		(
			settings:
			[
				./stylix/default.nix
				./options.nix

				{ jcconfs = { inherit (settings) profiles; wallpapers_path = ./.wallpapers; }; }
			]
		);

		getNixosModules = (
			settings:
			(getCommonModules settings) ++
			[
				inputs.stylix.nixosModules.stylix
				./stylix/nixos.nix
			]
		);

		getHomeManagerModules = (
			settings:
			(getCommonModules settings) ++
			[
				inputs.stylix.homeModules.stylix
				./stylix/hm.nix

				./modules/default.nix

				{ jcconfs = { inherit (settings) has-de is-laptop; }; }
			]
		);

		getUserModules = (
			username:
			[
				{ home.username = username; }
				{ jcconfs.username = username; }
			]
		);

		homeConfiguration = (
			{ config, lib, ... }:
			let
				args = (getArgs { inherit (config.jcconfs) username has-de is-laptop; });
				inherit (args) settings;
			in
			{
				imports = [ ]
				++ (getNixosModules settings)
				++ [ 
					home-manager.nixosModules.home-manager
					{
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = args;
						home-manager.users = builtins.listToAttrs
						(
							let
								keyValue = (name: value: { inherit name value; });
							in
							builtins.map (
								username:
								keyValue username (
									{ ... }:
									{
										imports = [ ]
										++ (getHomeManagerModules settings)
										++ (getUserModules username)
										;

										stylix.enable = true && settings.has-de;
									}
								)
							) nx-users
						);
					}
				];
			}
		);

		homeBuilder = (
			{ username, has-de, is-laptop, pkgs }:
			let
				args = getArgs { inherit username has-de is-laptop; };
			in
			home-manager.lib.homeManagerConfiguration {
				extraSpecialArgs = args;
				inherit pkgs;

				modules = [ ]
				++ (getHomeManagerModules args.settings)
				++ (getUserModules username)
				;
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
		nixosModules =
		{
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
					(builtins.map    (username: map-user username { has-de = false; is-laptop = false; }) hm-users)
					++ (builtins.map (username: map-user username { has-de = true;  is-laptop = false; }) hm-users)
					++ (builtins.map (username: map-user username { has-de = false; is-laptop = true;  }) hm-users)
					++ (builtins.map (username: map-user username { has-de = true;  is-laptop = true;  }) hm-users)
				)
			)
		);

		# nix build
		packages = forAllSystems
		(
			system:
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
					(builtins.map    (username: map-user username { has-de = false; is-laptop = false; }) hm-users)
					++ (builtins.map (username: map-user username { has-de = true;  is-laptop = false; }) hm-users)
					++ (builtins.map (username: map-user username { has-de = false; is-laptop = true;  }) hm-users)
					++ (builtins.map (username: map-user username { has-de = true;  is-laptop = true;  }) hm-users)
				)
			)
		);
	};
}
