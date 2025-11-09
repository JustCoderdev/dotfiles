{ config, lib, pkgs, ... }:

let
	cfg = config.common.core.plymouth;
in

{
	# Check what VGA graphics driver is installed
	# lspci -v | grep -A10 VGA | grep driver

	config = lib.mkIf (cfg.enable)
	{
		boot =
		{
			#"plymouth.debug" # log at /var/log/plymouth-debug.log
			kernelParams = [ "quiet" ]; # "plymouth.use-simpledrm"
			initrd.systemd.enable = true;
			plymouth =
			{
				enable = true;
				theme = "darnix";
				themePackages = [ (pkgs.callPackage ../../unofficial/pkgs/darnix-plymouth-theme { }) ];
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.plymouth =
	{
		enable = lib.mkEnableOption "plymouth boot graphics";
	};
}
