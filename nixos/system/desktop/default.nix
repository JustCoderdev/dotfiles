{ pkgs, config, lib, ... }:

let
	self-manifest = config.common.manifest.self;
	desktop-environment-enabled = self-manifest.hardware.graphics.desktop-environment.enable;
in

{
	imports =
	[
		./xserver
		./wayland
	];

	config = lib.mkIf (desktop-environment-enabled)
	{
		xdg.portal =
		{
			enable = true;
			extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
			config.common.default = [ "gtk" ];
		};
	};
}
