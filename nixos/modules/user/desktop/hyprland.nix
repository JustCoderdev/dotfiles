{ settings, ... }:

let
	dotfiles = settings.dotfiles_path;
	configpath = settings.config_path;
in
{
	wayland.windowManager.hyprland = {
		enable = true;
		systemdIntegration = true;
		nvidiaPatches = false;
		extraConfig = (builtins.readFile
			 "${dotfiles}/hypr/hyprland.conf");
	};
}
