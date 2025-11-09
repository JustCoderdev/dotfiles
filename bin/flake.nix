# Idea from
# <https://discourse.nixos.org/t/how-to-pass-through-nixosmodules-in-flakes/18064/3>

{
	description = "JC Binary Executables";

	inputs.nixpkgs.url = "nixpkgs/nixos-25.05";

	outputs = { self, nixpkgs }:
	let
		binaries =
		[
			{ name = "boomer"; }
			{ name = "backlight"; requiresSudo = true; }
			{ name = "gopro-control";}
		];

		scripts =
		[
			{ name = "eep"; requiresSudo = true; }
			{ name = "mount-configs";  }
			{ name = "rebuild-system"; }
			{ name = "umount-configs"; }
		];

		packageBinary = (name: pkgs: pkgs.callPackage ./binaries/${name}/default.nix { });
		packageScript =
		(
			name: getInputs: pkgs:
			pkgs.writeShellApplication {
				inherit name;
				runtimeInputs = getInputs pkgs;
				text = (builtins.readFile ./scripts/${name}.sh);
			}
		);

		generateModule = (
			name: requiresSudo: getPackage:
			{ config, lib, pkgs, ... }:
			let
				cfg = config.jcbin.${name};
				pkg = getPackage pkgs;
			in
			{
				config = lib.mkIf (cfg.enable)
				{
					environment.systemPackages =  [ pkg ];
					security.sudo.extraRules  = lib.mkIf (requiresSudo) [{
						groups = [ "users" ];
						commands = [{
							command = "${config.system.path}/bin/${name}";
							options = [ "NOPASSWD" ];
						}];
					}];
				};

				options.jcbin.${name}.enable = lib.mkEnableOption "${name} and add it to 'PATH'";
			}
		);

		generateScriptModule = (
			{ name, getInputs ? (pkgs: []), requiresSudo ? false }:
			generateModule name requiresSudo (pkgs: packageScript name getInputs pkgs)
		);

		generateBinaryModule = (
			{ name, requiresSudo ? false }:
			generateModule name requiresSudo (pkgs: packageBinary name pkgs)
		);

		modules = { }
		//
		builtins.listToAttrs
		(
			(
				builtins.map
					(data: { inherit (data) name; value = (generateBinaryModule data); })
					(binaries)
			) ++ (
				builtins.map
					(data: { inherit (data) name; value = (generateScriptModule data); })
					(scripts)
			)
		)
		;

		lib = nixpkgs.lib;
		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = lib.attrsets.genAttrs supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
	in
	{
		nixosModules = (modules)
		// { all = ({ imports = builtins.attrValues modules; }); }
		;

		packages = forAllSystems (
			system:
			let
				pkgs = nixpkgsFor.${system};
			in
			builtins.listToAttrs
			(
				(
					builtins.map (
						{ name, getInputs ? (pkgs: []), ... }:
						{ inherit name; value = (packageScript name getInputs pkgs); }
					) (scripts)
				)
				++
				(
					builtins.map (
						{ name, ... }:
						{ inherit name; value = (packageBinary name pkgs); }
					) (binaries)
				)
			)
		);
	};
}
