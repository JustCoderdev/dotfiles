{ pkgs, ... }:

{
	environment.systemPackages = [ pkgs.openvpn ];
}
