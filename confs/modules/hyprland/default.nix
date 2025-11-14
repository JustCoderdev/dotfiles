{ settings, ... }:

let
	inherit (settings) wallpapers_path has-de;
in

{
	wayland.windowManager.hyprland = lib.mkIf (has-de)
	{
		enable = true;
		systemd.enable = true;

		settings = {
			input = {
				touchpad = {
					middle_button_emulation = false;
					tap_button_map = "lrm";
				};
				accel_profile = "flat";
				kb_layout = "it";
				kb_options = "grp_led:scroll,caps:ctrl_modifier,numpad:mac";
				numlock_by_default = true;
				scroll_method = "twofinger";
			};
			exec-once = "swww-daemon --format xrgb";
			exec = "swww img ${wallpapers_path}/space_engineers.png";
		};

		extraConfig = (builtins.readFile ./hyprland.conf);
	};
}
