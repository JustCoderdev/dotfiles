{ config, lib, pkgs, ... }:

let
	cfg = config.jcconfs.module.vr;
in

{
	config = lib.mkIf (cfg.enable)
	{
		xdg.configFile =
		{
			"openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
			"openvr/openvrpaths.vrpath".text =
			(
				let steam = "${config.xdg.dataHome}/Steam"; in
				builtins.toJSON
				{
					version = 1;
					jsonid = "vrpathreg";
					external_drivers = null;

					config  = [ "${steam}/config" ];
					log     = [ "${steam}/logs"   ];
					runtime = [ "${pkgs.xrizer}/lib/xrizer" ];
					# OR "${pkgs.opencomposite}/lib/opencomposite"
					# OR "${pkgs.vapor}/lib/VapoR"
				}
			);
		};

	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.vr =
	{
		enable = lib.mkEnableOption "vr compatibility hacks";
	};
}
