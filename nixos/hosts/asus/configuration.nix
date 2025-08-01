{ pkgs, ... }:

{
	hardware.nvidia.prime = {
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:2:0:0";
	};

	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};
}
