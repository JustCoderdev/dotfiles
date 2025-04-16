{ config, lib, pkgs, ... }:

let
	cfg = config.jcbin.boomer;
	nim_1_0 = pkgs.callPackage ./overlay/nim_1_0.nix {};
	package = pkgs.callPackage ./overlay/boomer.nix { inherit nim_1_0; };
in

{
	config = lib.mkIf cfg.enable
	{
		environment.systemPackages = [ package ];
	};

	# ------------------------------------------------------------ #

	options.jcbin.boomer =
	{
		enable = lib.mkEnableOption "Add boomer to PATH";
	};
}
