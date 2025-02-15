{ config, lib, pkgs, ... }:

let
	cfg = config.system.bin.rebuild-system;
	package = pkgs.writeShellApplication {
		name = "rebuild-system";
		runtimeInputs = with pkgs; [ git vim ];
		text = (builtins.readFile ./rebuild-system.sh);
	};
in

{
	config = lib.mkIf cfg.enable {
		security.sudo = {
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

	options.system.bin.rebuild-system = {
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add rebuild-system to PATH";
			default = true;
		};
	};
}
