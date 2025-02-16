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
		darnix-overlay = (
			final: prev: { darnix-plymouth-theme = jcconfs.packages.darnix-plymouth-theme; }
		);

		getModules = (
			settings: [
				jcbin.nixosModules.all
				jcconfs.nixosModule.home { inherit (settings) username special_pkgs; };
				./nixos
			]
#			++
#			(let diskopath = "./nixos/hosts/${_hostname}/disko.nix"; in
#				nixpkgs.lib.optionals (nixpkgs.lib.pathExists diskopath) [
#					diskopath
#					disko.nixosModules.disko
#				]
#			);
		);

		systemBuilder = (
			{ hostname, system, username }:
			let
				settings = {
					inherit hostname;
					inherit system;
					inherit (import ./settings/users/${username}.nix) username special_pkgs;
				};
			in
			nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs settings darnix-overlay; };
				modules = (getModules settings) ++ [
					./settings/hosts/${hostname}/hardware-configuration.nix
					./settings/hosts/${hostname}/boot.nix
					./settings/hosts/${hostname}/options.nix
					./settings/hosts/${hostname}/configuration.nix
				];
			}
		);

		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
	in

	{
		# nixos-rebuild switch --flake .#<hostname>
		nixosConfigurations = {
			virtualmachine = systemBuilder "virtualmachine" "x86_64-linux" "ryuji";
			msi            = systemBuilder "msi"            "x86_64-linux" "ryuji";
			acer           = systemBuilder "acer"           "x86_64-linux" "ryuji";
			quiss          = systemBuilder "quiss"          "x86_64-linux" "ryuji";
		};

		# nix build
		# packages.${system} = { };

		# nix run
		apps = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in
			{
				# install = {
				# 	type = "app";
				# 	program = "...";
				# };
			}
		);

		# nix develop
		devShell = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in
			{
				default = pkgs.mkShell {
					shellHook = '' zsh && exit '';
					buildInputs = with pkgs; [ git vim ];
				};
			}
		);
	};
}
