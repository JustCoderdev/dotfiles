{
	description = "JC NixOS System flake";

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-25.05";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

		jcbin = {
			url = "path:./bin";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		jcconfs = {
			url = "path:./confs";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-minecraft = {
			url = "github:Infinidoge/nix-minecraft";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# disko = {
		# 	url = "github:nix-community/disko/v1.11.0";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, jcbin, jcconfs, nix-minecraft }@inputs:
	let
		dotfiles = ./.;

		# TODO: Create manifest for each directory under `nixos/hosts`
		hosts-list =
		let
			add-host = (
				hostname: system: username:
				{ inherit hostname system username; }
			);
		in
		[
			(add-host "virtualmachine" "x86_64-linux"  "ryuji")

			(add-host "alpha"          "x86_64-linux"  "ryuji")
			(add-host "beta"           "x86_64-linux"  "ryuji")

			(add-host "quiss"          "x86_64-linux"  "ryuji")
			(add-host "jarvis"         "aarch64-linux" "ryuji")

			(add-host "msi"            "x86_64-linux"  "ryuji")
			(add-host "acer"           "x86_64-linux"  "ryuji")
			(add-host "asus"           "x86_64-linux"  "ryuji")
		];

		# hosts-data = builtins.listToAttrs (
		# 	builtins.map (
		# 		host-data:
		# 		{
		# 			name = host-data.hostname;
		# 			value = host-data;
		# 		}
		# 	) hosts-list
		# );

		lib = nixpkgs.lib;

		getUserModules = (
			username:
			[
				jcbin.nixosModules.all
				jcconfs.nixosModules.home { jcconfs.username = username; }
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
			host-data: is-raspi3:
			{
				inherit (host-data) hostname system;
				inherit (import ./confs/settings/${host-data.username}.nix) username dotfiles_path special_pkgs;
				inherit is-raspi3;
			}
		);

		getUnstablePackages = (
			settings:
			import nixpkgs-unstable {
				inherit (settings) system;
				config = let spkgs = settings.special_pkgs; in {
					permittedInsecurePackages = spkgs.insecure;
					allowUnfreePredicate = pkg: builtins.elem
						(nixpkgs.lib.getName pkg) spkgs.unfree;
				};
			}
		);


		# System builders
		# ------------------------------------------------------------ #

		host-system-builder = (
			host-data:
			let
				settings = getSettings host-data false;
				pkgs-unstable = getUnstablePackages settings;
			in
			lib.nixosSystem {
				inherit (host-data) system;
				specialArgs = { inherit inputs pkgs-unstable settings dotfiles; };
				modules = (getHostModules host-data.hostname) ++ (getUserModules host-data.username);
			}
		);


		# Iso-cd builders
		# ------------------------------------------------------------ #

		host-iso-cd-builder = (
			host-data:
			let
				settings = getSettings host-data false;
				pkgs-unstable = getUnstablePackages settings;
			in
			lib.nixosSystem {
				inherit (host-data) system;
				specialArgs = { inherit inputs pkgs-unstable settings dotfiles; };
				modules = (getHostModules host-data.hostname) ++ (getUserModules host-data.username)
				++ [
					({ modulesPath, ... }: {
						imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
					})
				];
			}
		);

		iso-cd-builder = (
			system: username:
			let
				settings = getSettings { inherit system username; hostname = "nixiso"; } false;
				pkgs-unstable = getUnstablePackages settings;
			in
			lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs pkgs-unstable settings dotfiles; };
				modules = (getUserModules username)
				++ [
					({ pkgs, modulesPath, ... }: {
						imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
						jcbin.rebuild-system.enable = true;
					})
				];
			}
		);


		# Img-Sd builders
		# ------------------------------------------------------------ #

		host-raspi3-img-sd-builder = (
			build-platform-system: host-data:
			let
				settings = getSettings host-data true;
				pkgs-unstable = getUnstablePackages settings;
			in
			lib.nixosSystem {
				inherit (host-data) system;
				specialArgs = { inherit inputs pkgs-unstable settings dotfiles; };
				modules = (getHostModules host-data.hostname) ++ (getUserModules host-data.username)
				++ [
					({ settings, ... }: {
						jcbin.rebuild-system.enable = true;
						common.core.hardware.is-raspi3 = true;

						# -------------------- #

						# Enable cross compilation
						nixpkgs.config.allowUnsupportedSystem = true;
						nixpkgs.hostPlatform = { inherit (settings) system; };
						nixpkgs.buildPlatform.system = build-platform-system;
					})
				];
			}
		);

		raspi3-img-sd-builder = (
			build-platform-system: username:
			let
				settings = getSettings { inherit username; hostname = "niximg"; system = "aarch64-linux"; } true;
				pkgs-unstable = getUnstablePackages settings;
			in
			lib.nixosSystem {
				inherit (settings) system;
				specialArgs = { inherit inputs pkgs-unstable settings dotfiles; };
				modules = (getUserModules settings)
				++ [
					({ pkgs, modulesPath, ... }: {
						imports = [
							./nixos/common/core
							./nixos/common/users
							./nixos/system/services/nixbuilder.nix
						];

						jcbin.rebuild-system.enable = true;
						common.core.hardware.is-raspi3 = true;

						# -------------------- #

						# Enable cross compilation
						nixpkgs.config.allowUnsupportedSystem = true;
						nixpkgs.hostPlatform = { inherit (settings) system; };
						nixpkgs.buildPlatform.system = build-platform-system;
					})
				];
			}
		);


		# ------------------------------------------------------------ #

		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = lib.genAttrs supportedSystems;
		listAllSystems = lib.lists.forEach supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
	in

	{
		# nixos-rebuild switch --flake .#<hostname>
		nixosConfigurations = { }
		//
		# System builders
		# -------------------- #
		builtins.listToAttrs (
			builtins.map (
				host-data:
				{
					name = host-data.hostname;
					value = host-system-builder host-data;
				}
			) hosts-list
		)
		//
		# Iso-cd builders
		# -------------------- #
		builtins.listToAttrs (
			builtins.map (
				host-data:
				let inherit (host-data) hostname username system; in
				{
					name = "${hostname}-${username}_iso-cd_${system}";
					value = host-iso-cd-builder host-data;
				}
			) hosts-list
		)
		//
		builtins.listToAttrs (
			listAllSystems (
				system:
				{
					name = "nixiso-ryuji_iso-cd_${system}";
					value = iso-cd-builder system "ryuji";
				}
			)
		)
		//
		# Img-Sd builders
		# -------------------- #
		builtins.listToAttrs (
			lib.lists.flatten (
				listAllSystems (
					build-platform-system:
					builtins.map (
						host-data:
						let inherit (host-data) hostname username system; in
						{
							name = "${hostname}-${username}_raspi3-img-sd_${system}_build-from_${build-platform-system}";
							value = host-raspi3-img-sd-builder build-platform-system host-data;
						}
					) (
						builtins.filter (host-data: host-data.system == "aarch64-linux") hosts-list
					)
				)
			)
		)
		//
		builtins.listToAttrs (
			listAllSystems (
				build-platform-system:
				{
					name = "niximg-ryuji_raspi3-img-sd_aarch64-linux_build-form_${build-platform-system}";
					value = raspi3-img-sd-builder build-platform-system "ryuji";
				}
			)
		);

		# nix build
		# packages.${system} = { };

		# nix run
		# apps = forAllSystems (
		# 	system:
		# 	let pkgs = nixpkgsFor.${system}; in
		# 	{
				# test-iso-x86_64 = {
				# 	type = "app";
				# 	program = "nix-shell -p qemu --command 'qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso'";
				# };

				# build-img-raspi3 = {
				# 	type = "app";
				# 	program = "nix build .#nixosConfigurations.img-raspi3.config.system.build.sdImage";
				# };
			# }
			# //
			# builtins.listToAttrs (
			# 	listAllSystems (
			# 		system: let pkgs = nixpkgsFor.${system}; in
			# 		{
			# 			name = "build-iso-cd-${system}";
			# 			value = {
			# 				type = "app";
			# 				program = "nix build .\\#nixosConfigurations.iso-cd-${system}.config.system.build.isoImage";
			# 			};
			# 		}
			# 	)
			# )
		# );

		# nix develop
		devShell = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in
			{
				default = pkgs.mkShell {
					shellHook = '' zsh && exit '';
					buildInputs = with pkgs; [ git vim zsh ];
				};
			}
		);
	};
}
