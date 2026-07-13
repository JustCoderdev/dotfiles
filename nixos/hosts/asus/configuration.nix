{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ geteduroam dbeaver-bin ];
	programs.nm-applet.enable = true;

	# Gnome
	# -------------------- #
	# services.xserver.displayManager.lightdm.greeters.gtk.indicators = lib.mkForce null;
	# services.xserver.desktopManager.gnome.enable = true;
	#
	# services.gnome.games.enable = false;
	#
	# common.core.audio.backend = "pipewire";
	# services.tlp.enable = false;
	# -------------------- #


	# Temporary services
	# ------------------------------------------------------------ #

	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};
}
