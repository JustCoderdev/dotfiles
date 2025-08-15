{ config, lib, ... }:

let
	cfg = config.stylix.module;
in

{
	stylix = lib.mkIf (cfg.has_de)
	{
		autoEnable = true;
		targets.plymouth.enable = false;
		targets.lightdm.enable = true;
	};
}
