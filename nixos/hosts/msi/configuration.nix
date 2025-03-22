{ pkgs, ... }:

{
	# Mouse support
	environment.systemPackages = with pkgs; [ piper ];
	services.ratbagd.enable = true;
}
