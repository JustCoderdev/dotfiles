{
	description = "JC Home Configuration flake";

	inputs =
	{
		nixpkgs.url = "nixpkgs/nixos-26.05";

		home-manager.url = "github:nix-community/home-manager/release-26.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		stylix.url = "github:danth/stylix/release-26.05";
		stylix.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, stylix }:
	let
		lib = nixpkgs.lib;

		users =
		(
			lib.attrsets.mapAttrsToList
				(username: _: builtins.replaceStrings [ ".nix" ] [ "" ] username)
				(
					lib.attrsets.filterAttrs
						(name: value: !(lib.strings.hasPrefix "." name) && (value == "regular"))
						(builtins.readDir ./settings)
				)
		);

		nixos-modules = [
			./stylix/default.nix

			stylix.nixosModules.stylix
			./stylix/nixos.nix

			./options/external.nix
		];

		home-manager-modules = [
			./stylix/default.nix

			stylix.homeModules.stylix
			./stylix/hm.nix

			./options/internal.nix
			./modules/default.nix
		];

		getUserModules = (
			username:
			let
				user-settings = import ./settings/${username}.nix;
			in
			[
				{ home = { inherit username; homeDirectory = "/home/${username}"; }; }
				{ jcconfs.user = { inherit (user-settings) profiles; }; }
				{
					nixpkgs.config = {
						permittedInsecurePackages = user-settings.special-pkgs.insecure;
						allowUnfreePredicate = pkg: builtins.elem
							(lib.getName pkg) user-settings.special-pkgs.unfree;
					};
				}
			]
		);

		homeConfiguration = (
			{ config, ... }:
			{
				imports = nixos-modules ++ [
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
									let
										inherit (config.jcconfs) host;
									in
									{
										imports = home-manager-modules ++ (getUserModules username);
										stylix.enable = true && host.has-de;
										jcconfs = { inherit host; };
									}
								)
							) config.jcconfs.users
						);
					}
				];
			}
		);

		homeBuilder = (
			username: { has-de, is-laptop }: pkgs:
			home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ ]
				++ home-manager-modules
				++ (getUserModules username)
				++ [ { jcconfs.host = { inherit has-de is-laptop; }; } ]
				;
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
		// forAllSystems
		(
			system:
			let
				map-user =
				(
					username: flags:
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
						username: flags:
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
