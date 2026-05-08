{ config, lib, pkgs, ... }:

let
	inherit (config.jcconfs) wallpapers_path;
	inherit (config.jcconfs.host) has-de;

	cfg = config.jcconfs.module.hyprland;
in

{
	config = lib.mkIf (cfg.enable && has-de)
	{
		wayland.windowManager.hyprland =
		{
			enable = true;
			systemd.enable = true;

			settings =
			{
				# TODO: Get monitor data from manifest?
				# monitors (`hyperctl monitor all`)
				# monitor=HDMI-A-1,1920x1080@60,0x0,1    # DIGIQuest
				# monitor=desc:ASUSTek COMPUTER INC ASUS VA24E L7LMTF289885,1920x1080@60,1920x0,1 # ASUS

				monitor = ", preferred, auto, 1";

				exec-once = [
					"waybar"
					"[workspace 1 silent] firefox"
					"[workspace 2] alacritty"
				];

				env = "XCURSOR_SIZE,24";
				exec = "${pkgs.swww}/bin/swww img ${wallpapers_path}/space_engineers.png";

				general =
				{
					border_size = 1;

					gaps_in = 2;
					gaps_out = 4;

					"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
					"col.inactive_border" = "rgba(595959aa)";

					layout = "dwindle";
				};

				decoration =
				{
					rounding = 5;

					blur =
					{
						enabled = false;
						size = 8;
						passes = 1;

						new_optimizations = true;
					};

					shadow =
					{
						enabled = true;
						range = 4;
						render_power = 3;
						ignore_window = true;
						color = "rgba(1a1a1aee)";
					};
				};

				animations.enabled = false;

				# TODO: grab input settings from libinput?
				input =
				{
					touchpad = {
						natural_scroll = true;
						middle_button_emulation = false;
						tap_button_map = "lrm";
					};
					follow_mouse = 1;
					accel_profile = "flat";
					kb_layout = "it";
					kb_options = "grp_led:scroll,caps:ctrl_modifier,numpad:mac";
					numlock_by_default = true;
					scroll_method = "twofinger";
				};

				gesture = "3, horizontal, workspace";

				misc = {
					disable_hyprland_logo = true;
					force_default_wallpaper = 2;
					middle_click_paste = false;
				};

				dwindle.preserve_split = true;

				master = {
					allow_small_split = true;
					new_status = "master";
				};

				ecosystem =
				{
					no_update_news = true;
					no_donation_nag = true;
				};


				# Keybindings
				# -------------------- #

				"$mod" = "SUPER";
				bind =
				[
					"$mod,       Return, exec,               alacritty"
					"$mod,       O,      exec,               obsidian"
					"$mod,       B,      exec,               firefox"
					"$mod,       F11,    fullscreenstate"
					"$mod SHIFT, Space,  togglefloating"
					"$mod SHIFT, R,      forcerendererreload"
					"$mod SHIFT, Q,      killactive"
					"$mod SHIFT, E,      exit"
					"$mod,       F,      fullscreen,         0"
					"$mod,       D,      exec,               rofi -show drun -show-icons"
					"$mod,       P,      pin"
					"$mod SHIFT, S,      exec,               grim -t png -c -g \"$(slurp -d )\" \"/home/$USER/Pictures/Screenshots/screenshot_$(date '+%Y-%m-%d_%H:%M:%S').png\""

					# change focus
					"$mod, h, movefocus, l"
					"$mod, l, movefocus, r"
					"$mod, k, movefocus, u"
					"$mod, j, movefocus, d"

					# move active window
					"$mod SHIFT, h, movewindoworgroup, l"
					"$mod SHIFT, l, movewindoworgroup, r"
					"$mod SHIFT, k, movewindoworgroup, u"
					"$mod SHIFT, j, movewindoworgroup, d"

					# resize active window        X   Y
					"$mod CTRL, h, resizeactive, -60   0"
					"$mod CTRL, l, resizeactive,  60   0"
					"$mod CTRL, k, resizeactive,   0 -60"
					"$mod CTRL, j, resizeactive,   0  60"

					# Tabbed group options
					"$mod, w, togglegroup"
					"$mod, h, changegroupactive, b"
					"$mod, l, changegroupactive, f"

					# Dwindle
					"$mod, e, togglesplit"

					# Switch to workspaces
					"$mod, 1, workspace, 1"
					"$mod, 2, workspace, 2"
					"$mod, 3, workspace, 3"
					"$mod, 4, workspace, 4"
					"$mod, 5, workspace, 5"
					"$mod, 6, workspace, 6"
					"$mod, 7, workspace, 7"
					"$mod, 8, workspace, 8"
					"$mod, 9, workspace, 9"

					# Move to workspace
					"$mod SHIFT, 1, movetoworkspacesilent, 1"
					"$mod SHIFT, 2, movetoworkspacesilent, 2"
					"$mod SHIFT, 3, movetoworkspacesilent, 3"
					"$mod SHIFT, 4, movetoworkspacesilent, 4"
					"$mod SHIFT, 5, movetoworkspacesilent, 5"
					"$mod SHIFT, 6, movetoworkspacesilent, 6"
					"$mod SHIFT, 7, movetoworkspacesilent, 7"
					"$mod SHIFT, 8, movetoworkspacesilent, 8"
					"$mod SHIFT, 9, movetoworkspacesilent, 9"
				];

				## "Borrowed" KEYBINDINGS
				# Source: <https://faq.i3wm.org/question/3747/enabling-multimedia-keys/?answer=3759#post-id-3759>

				bindel =
				[
					# Pulseaudio Audio controls
					",           XF86AudioRaiseVolume,  exec, amixer sset Master    5%+"
					",           XF86AudioLowerVolume,  exec, amixer sset Master    5%-"
					"     SHIFT, XF86AudioRaiseVolume,  exec, amixer sset Master   15%+"
					"     SHIFT, XF86AudioLowerVolume,  exec, amixer sset Master   15%-"
					"CTRL+SHIFT, XF86AudioRaiseVolume,  exec, amixer sset Master  100%+"
					"CTRL+SHIFT, XF86AudioLowerVolume,  exec, amixer sset Master  100%-"
					",           XF86AudioMute,         exec, amixer sset Master toggle"

					# Custom Screen brightness controls
					",           XF86MonBrightnessUp,   exec, sudo backlight inc  5%"
					",           XF86MonBrightnessDown, exec, sudo backlight dec  5%"
					"     SHIFT, XF86MonBrightnessUp,   exec, sudo backlight inc 15%"
					"     SHIFT, XF86MonBrightnessDown, exec, sudo backlight dec 15%"
					"CTRL+SHIFT, XF86MonBrightnessUp,   exec, sudo backlight set max"
					"CTRL+SHIFT, XF86MonBrightnessDown, exec, sudo backlight set   0"

					# Media player controls
					", XF86AudioPlay,  exec, ${pkgs.playerctl}/bin/playerctl play-pause" # playerctl play
					", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # playerctl pause
					", XF86AudioStop,  exec, ${pkgs.playerctl}/bin/playerctl stop"
					", XF86AudioPrev,  exec, ${pkgs.playerctl}/bin/playerctl previous"
					", XF86AudioNext,  exec, ${pkgs.playerctl}/bin/playerctl next"
				];

				bindm =
				[
					# Move/resize windows with mod + LMB/RMB and dragging
					"$mod, mouse:272, movewindow"
					"$mod, mouse:273, resizewindow"
				];
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.hyprland =
	{
		enable = lib.mkEnableOption "hyprland tiling window manager custom configuration";
	};
}
