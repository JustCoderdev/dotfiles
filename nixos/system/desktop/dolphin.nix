{ config, lib, pkgs, ... }:

let
	cfg = config.system.desktop.dolphin;
in

{
	config = lib.mkIf (cfg.enable)
	{
		environment.systemPackages = with pkgs.kdePackages;
		[
			qtsvg      # svg support
			kio-fuse   # mount remote filesystems
			kio-extras # extra protocols support
			dolphin
		];
	};

	# ------------------------------------------------------------ #

	options.system.desktop.dolphin =
	{
		enable = lib.mkEnableOption "dolphin file manager";
	};
}

