{ config, lib, pkgs, ... }:

let
	cfg = config.system.bin.mount-configs;
	package = pkgs.writeShellApplication {
		name = "mount-configs";
		text = (builtins.readFile ./mount-configs.sh);
	};
in

{
	config = lib.mkIf cfg.enable {
		environment.systemPackages =  [ package ];
	};

	options.system.bin.mount-configs = {
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add mount-configs to PATH";
			default = false;
		};
	};
}
