{ pkgs, ... }:

{
	boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

	# Mouse support
	environment.systemPackages = with pkgs; [ piper ];
	services.ratbagd.enable = true;
}
