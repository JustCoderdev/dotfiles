{ config, lib, pkgs, ... }:

let
	cfg = config.modules.services.uxplay;
in


{
	config = lib.mkIf (cfg.enable)
	{
		environment.systemPackages = with pkgs; [ uxplay ];

		networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall) [ 7000 7100 ];
		networking.firewall.allowedUDPPorts = lib.mkIf (cfg.openFirewall) [ 6000 6001 7011 ];
	};

	# ------------------------------------------------------------ #

	options.modules.services.uxplay =
	{
		enable = lib.mkEnableOption "uxplay service";
		openFirewall = lib.mkEnableOption "Open firewall";
	};
}
