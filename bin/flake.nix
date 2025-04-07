# Idea from
# <https://discourse.nixos.org/t/how-to-pass-through-nixosmodules-in-flakes/18064/3>

{
	description = "JC Binary Executables";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.11";
	};
	
	outputs = { self, nixpkgs, ... }:
	let
		programs = [ "backlight" ];
		bash-scripts = [
			{
				name = "mount-configs";
				getInputs = (pkgs: with pkgs; [ vim git ]);
			}
			{
				name = "rebuild-system";
				requiresSudo = true;
			}
		];

		packageShellScript = (
			name: getInputs: pkgs:
			pkgs.writeShellApplication {
				inherit name;
				runtimeInputs = (if (builtins.isFunction getInputs) then getInputs pkgs else []);
				text = (builtins.readFile ./bash-scripts/${name}.sh);
			}
		);

		generateBashScriptModule = (
			{ name, getInputs ? (pkgs: []), requiresSudo ? false }: (
				{ config, lib, pkgs, ... }:
				let
					cfg = config.jcbin.${name};
					package = packageShellScript name getInputs pkgs;
				in
				{
					config = lib.mkIf cfg.enable {
						security.sudo = lib.mkIf requiresSudo {
							extraRules = [{
								commands = [{
									command = "${package}/bin/rebuild-system";
									options = [ "NOPASSWD" ];
								}];
								groups = [ "wheel" ];
							}];
						};

						environment.systemPackages =  [ package ];
					};

					options.jcbin.${name}.enable = lib.mkEnableOption "Add ${name} to PATH";
				}
			)
		);

		lib = nixpkgs.lib;
		forEach = lib.lists.forEach;
		genAttrs = lib.attrsets.genAttrs;
		attrValues = lib.attrsets.attrValues;

		modules = (
			genAttrs programs (p: import ./${p}/default.nix)
		)
		//
		builtins.listToAttrs (
			forEach bash-scripts (
				sdata:
				{
					inherit (sdata) name;
					value = generateBashScriptModule sdata;
				}
			)
		);

		supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
		forAllSystems = lib.genAttrs supportedSystems;
		nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
	in
	{
		nixosModules = modules // {
			all = ( { ... }: { imports = attrValues modules; } );
		};

		packages = forAllSystems (
			system: let pkgs = nixpkgsFor.${system}; in
			builtins.listToAttrs (
				forEach bash-scripts (
					# { name, getInputs ? (pkgs: []), requiresSudo ? false }: (
					sdata:
					{
						inherit (sdata) name;
						value = packageShellScript sdata.name sdata.getInputs pkgs;
					}
				)
			)
		);
	};
}
