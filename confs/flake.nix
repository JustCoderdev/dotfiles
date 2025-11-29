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

	outputs = { self, nixpkgs, home-manager, stylix }:
	let
		lib = nixpkgs.lib;

		users =
		(
			lib.attrsets.mapAttrs
				(username: _: username)
				(
					lib.attrsets.filterAttrs
						(name: value: !(lib.strings.hasPrefix "." name) && (value == "regular"))
						(builtins.readDir ./settings)
				)
		);

		common-modules = [
			./stylix/default.nix
			./options.nix

			{ jcconfs = { wallpapers_path = ./.wallpapers; }; }
		];

		nixos-modules = (
			common-modules ++ [ stylix.nixosModules.stylix ./stylix/nixos.nix ]
		);

		home-manager-modules = (
			common-modules ++ [ stylix.homeModules.stylix ./stylix/hm.nix ./modules/default.nix ]
		);

		getUserModules = (
			username:
			[
				{
					home.username = username;
					jcconfs.users.${username} =
					{
						inherit (import ./settings/${username}.nix) profiles special-pkgs;
					};
				}
			]
		);

		homeConfiguration = (
			{ config, lib, ... }:
			let
				inherit (config.jcconfs) host users;
			in
			{
				imports = nixos-modules
				++ [
					home-manager.nixosModules.home-manager
					{
						home-manager.useUserPackages = true;
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
										imports = [
											./stylix/default.nix
											./options.nix

											{ jcconfs = { wallpapers_path = ./.wallpapers; }; }
											stylix.homeModules.stylix ./stylix/hm.nix ./modules/default.nix
										];

										home.username = username;
										# imports = home-manager-modules ++ (getUserModules username);
										stylix.enable = true && config.jcconfs.host.has-de;
										jcconfs = {
											inherit host;
											users =
											(
												lib.attrsets.mapAttrs'
												(
													username: _:
													{
														name = username;
														value = { inherit (import ./settings/${username}.nix) profiles special-pkgs; };
													}
												)
												users
											);
										};
									}
								)
							) (
								lib.attrsets.mapAttrsToList
									(name: _: name)
									config.jcconfs.users
							)
						);
					}
				];
			}
		);

		homeBuilder = (
			username: { has-de, is-laptop }: pkgs:
			home-manager.lib.homeManagerConfiguration {
				modules = home-manager-modules ++ (getUserModules username)
					++ [ { jcconfs.host = { inherit has-de is-laptop; }; } ];
				inherit pkgs;
			}
		);

		optionalString = (cond: str: if cond then str else "");
		get-flags =
		(
			{ has-de, is-laptop }:
			""
			+ optionalString has-de    "-de"
			+ optionalString is-laptop "-lp"
		);

		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
		# listAllSystems = nixpkgs.lib.lists.forEach supportedSystems;
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
						value = homeBuilder username flags nixpkgsFor.${system};
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
