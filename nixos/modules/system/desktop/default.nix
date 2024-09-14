{ lib, config, pkgs, ... }:

let
	nvidia = config.common.core.nvidia;
	video-editing = config.common.users.ryuji.video-editing;
in

{
	imports = [
		./xserver
		./wayland
	];

	config = {
		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-kde
				xdg-desktop-portal-gtk
			];
			config.common.default = [ "gtk" ];
		};

		hardware.opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
			extraPackages = [
				(lib.mkIf video-editing pkgs.intel-compute-runtime)
			];
		};
	};
}
