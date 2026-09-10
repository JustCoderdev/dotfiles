{
	description = "JC NixOS System flake";

	inputs =
	{
		nixpkgs.url = "nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

		jcbin.url = "path:bin";
		jcbin.inputs.nixpkgs.follows = "nixpkgs";

		jcconfs.url = "path:confs";
		jcconfs.inputs.nixpkgs.follows = "nixpkgs";

		jchw.url = "path:hardware";

		disko.url = "github:nix-community/disko/v1.13.0";
		disko.inputs.nixpkgs.follows = "nixpkgs";

		nix-minecraft.url = "github:Infinidoge/nix-minecraft";
		nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

		nix-net-lib.url = "github:0xCCF4/nix-net-lib";
		nixpkgs-xr.url  = "github:nix-community/nixpkgs-xr";
	};

	outputs = { nixpkgs, nixpkgs-unstable, jcbin, jcconfs, jchw, disko, nix-minecraft, nix-net-lib, nixpkgs-xr, ... }:
	let
		hosts =
		(
			nixpkgs.lib.attrsets.mapAttrs
			(
				hostname: _: # TODO: perform type checking
				import ./nixos/hosts/${hostname}/manifest.nix jchw.database
			)
			(
				nixpkgs.lib.attrsets.filterAttrs
					(name: value: !(nixpkgs.lib.strings.hasPrefix "." name) && (value == "directory"))
					(builtins.readDir ./nixos/hosts)
			)
		);

		getHardwareModules = (
			manifest:
			let
				inherit (manifest) hardware;
				opt = expr: val: if expr then [ val ] else [ ];
			in
			[ ]
			++ opt (hardware.type == jchw.database.type.raspi3) jchw.nixosModules.special.raspi3
			++ opt (hardware ? "gpu" && hardware.gpu.manufacturer == jchw.database.architecture.gpu.manufacturer.nvidia)
				(
					jchw.nixosModules.gpu.nvidia
					(
						{
							cpu = { inherit (hardware.cpu) manufacturer arch; };
							board = hardware.gpu;

							desktop_environment_available = hardware.graphics.desktop-environment.enable;
						} // (
							if ! (hardware ? "gpu_offload") then { } else
							{
								offload_enable      = hardware.gpu_offload.enable;
								offload_intelBusId  = hardware.gpu_offload.intelBusId;
								offload_nvidiaBusId = hardware.gpu_offload.nvidiaBusId;
							}
						)
					)
				)
		);

		getDiskoModules =
		(
			hostname:
			let
				disko-module = ./nixos/hosts/${hostname}/disko.nix;
				optionals = (expr: list: if expr then list else []);
			in
			(
				optionals (nixpkgs.lib.filesystem.pathIsRegularFile disko-module)
				[
					{ system.nixos.tags = [ "disko" ]; }
					disko.nixosModules.disko
					disko-module
				]
			)
		);

		getUserPreferences =
		(
			system: username:
			let
				inherit (import ./confs/settings/${username}.nix) special-pkgs;
			in
			rec {
				pkgs-cfg = {
					permittedInsecurePackages = special-pkgs.insecure;
					allowUnfreePredicate = pkg: builtins.elem
						(nixpkgs.lib.getName pkg) special-pkgs.unfree;
				};
				pkgs-unstable = (import nixpkgs-unstable { inherit system; config = pkgs-cfg; });
				settings = {
					inherit username;
					dotfiles_store_path = ./.;
				};
			}
		);

		_experimental.nix6OS-module = import ./_experiments/nix6OS-module.nix;
	in

	{
		# nixos-rebuild switch --flake .#<hostname>
		nixosConfigurations =
		{
			nixos = abort "dumbass";
		}
		//
		# Manifest
		# -------------------- #
		builtins.mapAttrs (
			hostname: manifest:
			let
				username = "ryuji";
				inherit (manifest.hardware) system;
				user-preferences = getUserPreferences system username;
			in
			nixpkgs.lib.nixosSystem
			{
				inherit system;
				specialArgs =
				{
					inherit (user-preferences) pkgs-unstable settings;
					inherit nix-minecraft nix-net-lib nixpkgs-xr;
					jchw = jchw.database;
				};

				modules = nixpkgs.lib.lists.flatten
				[
					jcbin.nixosModules.all
					jcconfs.nixosModules.home
					./nixos

					# Manifest modules
					{ common.manifest.hosts = hosts; }
					(getHardwareModules manifest)

					# Host modules
					{ networking.hostName = nixpkgs.lib.mkForce hostname; }
					./nixos/hosts/${hostname}/boot.nix
					./nixos/hosts/${hostname}/configuration.nix
					./nixos/hosts/${hostname}/options.nix
					./nixos/hosts/${hostname}/hardware-configuration.nix
					(getDiskoModules hostname)

					# User modules
					{ nixpkgs.config = user-preferences.pkgs-cfg; }

					# _experimental modules
					_experimental.nix6OS-module
				];
			}
		) hosts;
	};
}
