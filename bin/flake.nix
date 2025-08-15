# Idea from
# <https://discourse.nixos.org/t/how-to-pass-through-nixosmodules-in-flakes/18064/3>

{
	description = "JC Binary Executables";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.05";
	};
	
	outputs = { self, nixpkgs, ... }:
	let
		programs = [
			{ name = "boomer"; }
			{ name = "backlight"; requiresSudo = true; }
		];
		bash-scripts = [
			{ name = "mount-configs";  }
			{ name = "umount-configs"; }
			{ name = "rebuild-system"; }
			{ name = "eep";  requiresSudo = true; }
		];

		packageProgram = (name: pkgs: pkgs.callPackage ./${name}/default.nix { });
		packageShellScript = (
			name: getInputs: pkgs:
			pkgs.writeShellApplication {
				inherit name;
				runtimeInputs = getInputs pkgs;
				text = (builtins.readFile ./bash-scripts/${name}.sh);
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
				config = lib.mkIf cfg.enable
				{
					environment.systemPackages =  [ pkg ];
					security.sudo = lib.mkIf requiresSudo {
						extraRules = [{
							groups = [ "users" ];
							commands = [{
								command = "${config.system.path}/bin/${name}";
								options = [ "NOPASSWD" ];
							}];
						}];
					};
				};

				options.jcbin.${name}.enable = lib.mkEnableOption "Add ${name} to PATH";
			}
		);
		generateBashScriptModule = (
			{ name, getInputs ? (pkgs: []), requiresSudo ? false }:
			generateModule name requiresSudo (pkgs: packageShellScript name getInputs pkgs)
		);
		generateProgramModule = (
			{ name, requiresSudo ? false }:
			generateModule name requiresSudo (pkgs: packageProgram name pkgs)
		);

		lib = nixpkgs.lib;
		forEach = lib.lists.forEach;
		genAttrs = lib.attrsets.genAttrs;
		attrValues = lib.attrsets.attrValues;
		nameValuePair = lib.attrsets.nameValuePair;

		modules = { }
		//
		builtins.listToAttrs (
			forEach programs (
				pdata:
				nameValuePair pdata.name (generateProgramModule pdata)
			)
			++
			forEach bash-scripts (
				sdata:
				nameValuePair sdata.name (generateBashScriptModule sdata)
			)
		);

		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = lib.genAttrs supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
	in
	{
		nixosModules = (modules) // {
			all = ( { ... }: { imports = attrValues modules; } );
		};

		packages = forAllSystems (
			system:
			let
				pkgs = nixpkgsFor.${system};
			in
			builtins.listToAttrs (
				forEach bash-scripts (
					{ name, getInputs ? (pkgs: []), ... }:
					nameValuePair name (packageShellScript name getInputs pkgs)
				)
				++
				forEach programs (
					{ name, ... }:
					nameValuePair name (packageProgram name pkgs)
				)
			)
		);
	};
}
