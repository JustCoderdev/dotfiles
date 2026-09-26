{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ geteduroam ];

	# _experimental.nix6OS =
	# {
	# 	enable = true;
	# 	fs-uuid = "1A0D-5553";
	# };

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
}
