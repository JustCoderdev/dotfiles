{ lib, pkgs, ... }:

{
	options.jcconfs =
	{
		inherit (import ./common.nix { inherit lib pkgs; }) icon-theme host wallpapers_path;

		users = lib.mkOption {
			description = "User preferences";
			type = lib.types.listOf lib.types.str;
		};
	};
}
