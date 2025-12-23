{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ dbeaver-bin vscode uxplay ];
	networking.firewall.allowedTCPPorts = [ 7000 7100 ];
	networking.firewall.allowedUDPPorts = [ 6000 6001 7011 ];

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

	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};
}
