{ inputs, pkgs, config, lib, settings, ... }:

let
	cfg = config.common.core.plymouth;
	darnix-plymouth-theme = inputs.jcconfs.packages.${settings.system}.darnix-plymouth-theme;
in

{
	# Check what VGA graphics driver is installed
	# lspci -v | grep -A10 VGA | grep driver

	config = lib.mkIf cfg.enable
	{
		boot = {
			initrd.systemd.enable = true;
			
			#"plymouth.debug" # log at /var/log/plymouth-debug.log
			kernelParams = [ "quiet" "splash" ];

			plymouth = {
				enable = true;

				theme = "darnix";
				themePackages = [ darnix-plymouth-theme ];
			};
		};
	};

	options.common.core.plymouth = {
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable plymouth boot screen";
			default = false;
		};
	};
}
