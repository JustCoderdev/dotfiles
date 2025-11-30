{
	description = "JC NixOS System flake";

	inputs =
	{
		nixpkgs.url = "nixpkgs/nixos-25.05";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

		jcbin = {
			url = "path:bin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		jcconfs = {
			url = "path:confs";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, nixpkgs-unstable, jcbin, jcconfs, disko, ... }@inputs:
	let
		dotfiles_store_path = ./.;

		lib = nixpkgs.lib;
		jc-lib = import ./jc-lib.nix { inherit lib; };

		hosts =
		(
			lib.attrsets.mapAttrs
				(hostname: _: import ./nixos/hosts/${hostname}/manifest.nix)
				(
					lib.attrsets.filterAttrs
						(name: value: !(lib.strings.hasPrefix "." name) && (value == "directory"))
						(builtins.readDir ./nixos/hosts)
				)
		);

		getUserModules = (
			username:
			[
				jcbin.nixosModules.all
				jcconfs.nixosModules.home
				./nixos
			]
		);

		getHostModules = (
			hostname:
			[
				./nixos/hosts/${hostname}/hardware-configuration.nix
				./nixos/hosts/${hostname}/boot.nix
				./nixos/hosts/${hostname}/options.nix
				./nixos/hosts/${hostname}/configuration.nix
			]
		);

		getSettings = (
			hostname: system: hardware-type: username:
			{
				inherit hostname system hardware-type username dotfiles_store_path;
				inherit (import ./confs/settings/${username}.nix) special-pkgs;
			}
		);

		getUnstablePackages = (
			settings:
			import nixpkgs-unstable {
				inherit (settings) system;
				config = let spkgs = settings.special-pkgs; in {
					permittedInsecurePackages = spkgs.insecure;
					allowUnfreePredicate = pkg: builtins.elem
						(nixpkgs.lib.getName pkg) spkgs.unfree;
				};
			}
		);


		# # Iso-cd builders
		# # ------------------------------------------------------------ #

		# host-iso-cd-builder = (
		# 	host-data:
		# 	let
		# 		settings = getSettings host-data false;
		# 		pkgs-unstable = getUnstablePackages settings;
		# 	in
		# 	lib.nixosSystem {
		# 		inherit (host-data) system;
		# 		specialArgs = { inherit inputs pkgs-unstable settings jc-lib; };
		# 		modules = (getHostModules host-data.hostname) ++ (getUserModules host-data.username)
		# 		++ [
		# 			({ modulesPath, ... }: {
		# 				imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
		# 			})
		# 		];
		# 	}
		# );

		# iso-cd-builder = (
		# 	system: username:
		# 	let
		# 		settings = getSettings { inherit system username; hostname = "nixiso"; } false;
		# 		pkgs-unstable = getUnstablePackages settings;
		# 	in
		# 	lib.nixosSystem {
		# 		inherit system;
		# 		specialArgs = { inherit inputs pkgs-unstable settings jc-lib; };
		# 		modules = (getUserModules username)
		# 		++ [
		# 			({ pkgs, modulesPath, ... }: {
		# 				imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
		# 				jcbin.rebuild-system.enable = true;
		# 			})
		# 		];
		# 	}
		# );


		# # Img-Sd builders
		# # ------------------------------------------------------------ #

		# host-raspi3-img-sd-builder = (
		# 	build-platform-system: host-data:
		# 	let
		# 		settings = getSettings host-data true;
		# 		pkgs-unstable = getUnstablePackages settings;
		# 	in
		# 	lib.nixosSystem {
		# 		inherit (host-data) system;
		# 		specialArgs = { inherit inputs pkgs-unstable settings jc-lib; };
		# 		modules =
		# 		[
		# 			# (getHostModules host-data.hostname)
		# 			# ./nixos/hosts/${hostname}/hardware-configuration.nix
		# 			./nixos/hosts/${host-data.hostname}/boot.nix
		# 			./nixos/hosts/${host-data.hostname}/options.nix
		# 			./nixos/hosts/${host-data.hostname}/configuration.nix
		# 		]
		# 		++ (getUserModules host-data.username)
		# 		++ [
		# 			({ settings, ... }: {
		# 				jcbin.rebuild-system.enable = true;

		# 				# -------------------- #

		# 				# Enable cross compilation
		# 				nixpkgs.config.allowUnsupportedSystem = true;
		# 				nixpkgs.hostPlatform = { inherit (settings) system; };
		# 				nixpkgs.buildPlatform.system = build-platform-system;
		# 			})
		# 		];
		# 	}
		# );

		# raspi3-img-sd-builder = (
		# 	build-platform-system: username:
		# 	let
		# 		settings = getSettings { inherit username; hostname = "niximg"; system = "aarch64-linux"; } true;
		# 		pkgs-unstable = getUnstablePackages settings;
		# 	in
		# 	lib.nixosSystem {
		# 		inherit (settings) system;
		# 		specialArgs = { inherit inputs pkgs-unstable settings jc-lib; };
		# 		modules = (getUserModules username)
		# 		++ [
		# 			({ pkgs, modulesPath, ... }: {
		# 				imports = [
		# 					./nixos/common/core
		# 					./nixos/common/manifest
		# 					./nixos/common/users
		# 					./nixos/system/services/nixbuilder.nix
		# 				];

		# 				jcbin.rebuild-system.enable = true;
		# 				system.services.nixbuilder.client.builders =
		# 				let
		# 					gen-builder = (
		# 						hostName: maxJobs:
		# 						{ inherit hostName maxJobs; }
		# 					);
		# 				in
		# 				[
		# 					(gen-builder "alpha.home.lan" 8)
		# 					(gen-builder  "beta.home.lan" 6)
		# 					(gen-builder "quiss.home.lan" 4)
		# 				];

		# 				# -------------------- #

		# 				# Enable cross compilation
		# 				nixpkgs.config.allowUnsupportedSystem = true;
		# 				nixpkgs.hostPlatform = { inherit (settings) system; };
		# 				nixpkgs.buildPlatform.system = build-platform-system;
		# 			})
		# 		];
		# 	}
		# );


		# ------------------------------------------------------------ #

		# supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		# forAllSystems = lib.genAttrs supportedSystems;
		# listAllSystems = lib.lists.forEach supportedSystems;
		# nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
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
				settings = (getSettings hostname manifest.hardware.system manifest.hardware.type username);
				pkgs-unstable = (getUnstablePackages settings);
			in
			lib.nixosSystem {
				inherit (manifest.hardware) system;
				specialArgs = { inherit inputs pkgs-unstable jc-lib settings; };
				modules = (getHostModules hostname) ++ (getUserModules username)
				++
				[
					({ ... }: { common.manifest.hosts = hosts; })
				]
				++
				(
					let
						disko-module = ./nixos/hosts/${hostname}/disko.nix;
					in
					lib.optionals (lib.filesystem.pathIsRegularFile disko-module)
					[
						{ system.nixos.tags = [ "disko" ]; }
						disko.nixosModules.disko
						disko-module
					]
				);
			}
		) hosts;
		# //
		# # Iso-cd builders
		# # -------------------- #
		# builtins.listToAttrs (
		# 	builtins.map (
		# 		host-data:
		# 		let inherit (host-data) hostname username system; in
		# 		{
		# 			name = "${hostname}-${username}_iso-cd_${system}";
		# 			value = host-iso-cd-builder host-data;
		# 		}
		# 	) hosts-list
		# )
		# //
		# builtins.listToAttrs (
		# 	listAllSystems (
		# 		system:
		# 		{
		# 			name = "nixiso-ryuji_iso-cd_${system}";
		# 			value = iso-cd-builder system "ryuji";
		# 		}
		# 	)
		# )
		# //
		# # Img-Sd builders
		# # -------------------- #
		# builtins.listToAttrs (
		# 	lib.lists.flatten (
		# 		listAllSystems (
		# 			build-platform-system:
		# 			builtins.map (
		# 				host-data:
		# 				let inherit (host-data) hostname username system; in
		# 				{
		# 					name = "${hostname}-${username}_raspi3-img-sd_${system}_build-from_${build-platform-system}";
		# 					value = host-raspi3-img-sd-builder build-platform-system host-data.username;
		# 				}
		# 			) (
		# 				builtins.filter (host-data: host-data.system == "aarch64-linux") hosts-list
		# 			)
		# 		)
		# 	)
		# )
		# //
		# builtins.listToAttrs (
		# 	listAllSystems (
		# 		build-platform-system:
		# 		{
		# 			name = "niximg-ryuji_raspi3-img-sd_aarch64-linux_build-form_${build-platform-system}";
		# 			value = raspi3-img-sd-builder build-platform-system "ryuji";
		# 		}
		# 	)
		# )
		# //
		# Install ISO
		# -------------------- #
		# {
		# 	install-iso-x86_64-linux =
		# 	let
		# 		hostname = "install-iso";
		# 		username = "ryuji";
		# 		system = "x86_64-linux";

		# 		settings = getSettings hostname system username;
		# 	in
		# 	lib.nixosSystem
		# 	{
		# 		inherit system;
		# 		specialArgs = { inherit inputs jc-lib settings; };
		# 		modules =
		# 		[
		# 			({ pkgs, modulesPath, ... }: {
		# 				imports = [
		# 					"${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
		# 					"${modulesPath}/installer/scan/not-detected.nix"
		# 					"${modulesPath}/profiles/qemu-guest.nix"

		# 					jcbin.nixosModules.rebuild-system

		# 					./nixos/common/core
		# 					./nixos/common/users
		# 					./nixos/system/services/nixbuilder.nix
		# 					./nixos/unofficial/modules/cloudflared.nix
		# 				];

		# 				# # ----- avoid kernel panic ----- #
		# 				# boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15;
		# 				# boot.kernel.sysctl."kernel.panic" = 60;
		# 				# # ------------------------------ #

		# 				jcbin.rebuild-system.enable = true;
		# 				services.tlp.enable = lib.mkForce false;

		# 				system.services.nixbuilder.client.builders =
		# 				let
		# 					gen-builder = (
		# 						hostName: maxJobs:
		# 						{
		# 							inherit hostName maxJobs;
		# 							features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
		# 							systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" "armv7l-linux" "armv6l-linux" ];
		# 						}
		# 					);
		# 				in
		# 				[
		# 					(gen-builder "192.168.1.5" 6)
		# 					(gen-builder "10.0.0.9" 6)
		# 				];
		# 			})
		# 		];
		# 	};
		# };
	};
}
