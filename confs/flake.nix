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
		users = [ "ryuji" "nixos" "school" ];

		getArgs = (
			{ username, has-de, is-laptop }@configs:
			{
				inherit inputs;
				settings = (import ./settings/${username}.nix) // (configs)
			}
		);

		getModules = (
			settings:
			[
				./default.nix
				./stylix/hm.nix

				{
					jcconfs = {
						inherit (settings) username profiles has-de is-laptop;
						wallpapers_path = ./.wallpapers;
					};
				}
			]
		);

		homeConfiguration = (
			{ config, lib, ... }:
			let
				args = (getArgs { inherit (config.jcconfs) username has-de is-laptop; });
				inherit (args) settings;
			in
			{
				imports =
				[
					home-manager.nixosModules.home-manager
					{
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = args;
						home-manager.users.${settings.username} = (
							{ ... }:
							{
								imports = (getModules settings) // [ ./stylix/nixos.nix ];
								stylix.enable = true && settings.has-de;
							}
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
