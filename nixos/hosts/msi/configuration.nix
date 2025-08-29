{ pkgs, ... }:

{
	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	# Mouse support
	services.ratbagd.enable = true;
	environment.systemPackages = with pkgs; [ piper ]
	++ [ ciscoPacketTracer8 dbeaver-bin ]; # more packages support

	# networking.interfaces."wlp3s0".ipv4.routes = [
	# 	{
	# 		address = "10.255.255.248";
	# 		prefixLength = 30;
	# 		via = "192.168.7.1";
	# 		type = "unicast";
	# 	}
	# ];


	boot.kernelModules = [ "v4l2loopback" ];
	boot.extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_15.v4l2loopback ];
	networking.firewall.allowedUDPPorts = [ 8854 ]; # GoPro 
	system.services.rtmp = {
		enable = true;
		openFirewall = true;
		proxy.enable = true;
	};
}
