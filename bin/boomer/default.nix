{ config, lib, pkgs, ... }:

let
	cfg = config.jcbin.boomer;
	nim_1_0 = pkgs.callPackage ./nim_1_0.nix {};
	package = pkgs.callPackage ./boomer.nix { inherit nim_1_0; };
in

{
	config = lib.mkIf cfg.enable
	{
		environment.systemPackages = [ package ];
	};

	options.jcbin.boomer = {
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Add boomer to PATH";
			default = false;
		};
	};
}
