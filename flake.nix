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
					hostname: _:
					# TODO: perform type checking
					import ./nixos/hosts/${hostname}/manifest.nix jchw.database
				)
				(
					nixpkgs.lib.attrsets.filterAttrs
						(name: value: !(nixpkgs.lib.strings.hasPrefix "." name) && (value == "directory"))
						(builtins.readDir ./nixos/hosts)
				)
		);

		getNixpkgsConfig =
		(
			spkgs:
			{
				permittedInsecurePackages = spkgs.insecure;
				allowUnfreePredicate = pkg: builtins.elem
						(nixpkgs.lib.getName pkg) spkgs.unfree;
			}
		);

		getUserModules = (
			username:
			let
				spkgs = (import ./confs/settings/${username}.nix).special-pkgs;
			in
			[
				jcbin.nixosModules.all
				jcconfs.nixosModules.home
				./nixos

				{ nixpkgs.config = getNixpkgsConfig spkgs; }
			]
		);

		getHostModules = (
			hostname:
			[
				{ networking.hostName = nixpkgs.lib.mkForce hostname; }
				./nixos/hosts/${hostname}/boot.nix
				./nixos/hosts/${hostname}/configuration.nix
				./nixos/hosts/${hostname}/options.nix
				./nixos/hosts/${hostname}/hardware-configuration.nix
			]
		);

		getManifestModules = (
			manifest:
			let
				inherit (manifest) hardware;
				opt = expr: val: if expr then [ val ] else [ ];
			in
			[ ]
			++ opt (hardware.type == jchw.database.type.raspi3) jchw.nixosModules.special.raspi3
			++ opt (hardware.gpu.manufacturer == jchw.database.architecture.gpu.manufacturer.nvidia)
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

		getSettings = (
			username:
			{
				inherit username;
				dotfiles_store_path = ./.;
			}
		);

		getUnstablePackages = (
			system: special-pkgs:
			import nixpkgs-unstable {
				inherit system;
				config = getNixpkgsConfig special-pkgs;
			}
		);

		nix6OS-module = import ./_experiments/nix6OS-module.nix;
	in

	{
		# nixos-rebuild switch --flake .#<hostname>
		nixosConfigurations = { }
		//
		# Manifest
		# -------------------- #
		builtins.mapAttrs (
			hostname: manifest:
			let
				username = "ryuji";
				inherit (manifest.hardware) system type;

				settings = (getSettings username);
				pkgs-unstable = (getUnstablePackages system settings.special-pkgs);

				optionals = (expr: list: if expr then list else []);
			in
			nixpkgs.lib.nixosSystem
			{
				inherit system;
				specialArgs =
				{
					inherit pkgs-unstable settings nix-minecraft nix-net-lib nixpkgs-xr;
					jchw = jchw.database;
				};

				modules = [ ]
				++ (getHostModules hostname)
				++ (getUserModules username)
				++ (getManifestModules manifest)
				++ [ { common.manifest.hosts = hosts; } nix6OS-module ]
				++ (
					let
						disko-module = ./nixos/hosts/${hostname}/disko.nix;
					in
					(
						optionals (nixpkgs.lib.filesystem.pathIsRegularFile disko-module)
						[
							{ system.nixos.tags = [ "disko" ]; }
							disko.nixosModules.disko
							disko-module
						]
					)
				)
				;
			}
		) hosts;
	};
}
