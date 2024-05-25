{ settings, ... }:

let
	dotfiles = settings.dotfiles_path;
in
{
	wayland.windowManager.hyprland = {
		enable = true;
		systemdIntegration = true;
		extraConfig = (builtins.readFile
			 "${dotfiles}/hypr/hyprland.conf");
	};
}
