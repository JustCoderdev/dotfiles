{
	description = "JC NixOS System flake";

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-24.11";
		# nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		jcbin = {
			url = "path:./bin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		jcconfs = {
			url = "path:./confs";
			inputs.nixpkgs.follows = "nixpkgs";
		};

#		disko = {
#			url = "github:nix-community/disko/v1.11.0";
#			inputs.nixpkgs.follows = "nixpkgs";
#		};
	};

	outputs = { self, nixpkgs, jcbin, jcconfs }@inputs:
	let
		_username = "ryuji";
		_hostname = "msi";
		system = "x86_64-linux";

		pkgs = nixpkgs.legacyPackages.${system};
		# pkgs-unstable = import nixpkgs-unstable {
		# 	system = settings.system;
		# 	config = let pkgs = settings.special_pkgs; in {
		# 		permittedInsecurePackages = pkgs.insecure;
		# 		allowUnfreePredicate = pkg: builtins.elem
		# 			(nixpkgs.lib.getName pkg) pkgs.unfree;
		# 	};
		# };

		args = {
			inherit inputs system;
			hostname = _hostname;
			username = _username;
		};
		system-modules = [
			jcbin.nixosModules.all
			jcconfs.nixosModules.${_username};
			./nixos/profiles/configuration.nix
		];
#		++
#		(let diskopath = "./nixos/hosts/${settings.hostname}/disko.nix"; in
#			nixpkgs.lib.optionals (nixpkgs.lib.pathExists diskopath) [
#				diskopath
#				disko.nixosModules.disko
#			]
#		);

		systemBuilder = (
			hostname: nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = args;
				modules = system-modules ++ [
					./nixos/hosts/${hostname}/hardware-configuration.nix
					./nixos/hosts/${hostname}/boot.nix
					./nixos/hosts/${hostname}/options.nix
					./nixos/hosts/${hostname}/configuration.nix
				];
			}
		);
	in

	{
		# nixos-rebuild switch --flake .#<hostname>
		nixosConfigurations.${_hostname} = systemBuilder ${_hostname};

		# nix build
		# packages.${settings.system} = { };

		# nix run
		apps.${system} = {
			# install = {
			# 	type = "app";
			# 	program = "...";
			# };
		};

		# nix develop
		devShell.${system} = {
			default = pkgs.mkShell {
				shellHook = '' zsh && exit '';
				buildInputs = with pkgs; [ git vim ];
			};
		};
	};
}
