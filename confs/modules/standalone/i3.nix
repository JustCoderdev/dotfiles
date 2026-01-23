{ config, lib, pkgs, ... }:

let
	inherit (config.jcconfs.host) has-de;

	cfg = config.jcconfs.module.i3;

	col = with config.stylix.base16Scheme;
	{
		background     = base00; # ----
		alt-background = base02; # ---

		unfocused      = base04; # +
		text           = base05; # ++

		error          = base08; # red
		focused        = base0D; # cyan
	};
in

{
	config = lib.mkIf (cfg.enable && has-de)
	{
		xsession.windowManager.i3 =
		let
			vim-mode = true;
			kl = if vim-mode then "h" else "Left";
			kd = if vim-mode then "j" else "Down";
			ku = if vim-mode then "k" else "Up";
			kr = if vim-mode then "l" else "Right";

			i3-cfg = config.xsession.windowManager.i3.config;
			mod = i3-cfg.modifier;
		in
		{
			enable = true;
			config =
			{
				modifier = "Mod4";

				fonts = {
					names = lib.mkForce [ "${config.stylix.fonts.monospace.name}" ];
					style = "Medium";
				};

				keybindings =
				let
					exec = (command: "exec --no-startup-id \"${command}\"");
					exec-n-reload-bar = (command: (exec "${command} && killall -s USR1 -- i3status"));
					workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
				in
				{
					# Custom keybindings

					"${mod}+Return"  = (exec "alacritty");
					"${mod}+b"       = (exec "firefox");
					"${mod}+t"       = (exec "thunar");
					"${mod}+Ctrl+l"  = (exec "${pkgs.lightlocker}/bin/light-locker-command -l");
					"${mod}+o"       = (exec "obsidian");
					"${mod}+p"       = (exec "pavucontrol");

					"${mod}+Z"       = (exec "boomer");
					"${mod}+F4"      = "exec \"i3-nagbar -m 'Click here if you want to shutdown the system' -B 'Shut now' 'shutdown now' -B 'Reboot' 'shutdown -r now' -B 'Cancel' 'shutdown -c'\"";
					"${mod}+Shift+s" = "exec ${pkgs.shotgun}/bin/shotgun $(hacksaw -f '-i %i -g %g') \"/home/$USER/Pictures/Screenshots/screenshot_$(date '+%Y-%m-%d_%H:%M:%S').png\"";


					# Various controls
					# Source: <https://faq.i3wm.org/question/3747/enabling-multimedia-keys/?answer=3759#post-id-3759>

					# Pulseaudio
							   "XF86AudioRaiseVolume" = (exec-n-reload-bar "amixer sset Master    5%+");
							   "XF86AudioLowerVolume" = (exec-n-reload-bar "amixer sset Master    5%-");
						 "Shift+XF86AudioRaiseVolume" = (exec-n-reload-bar "amixer sset Master   15%+");
						 "Shift+XF86AudioLowerVolume" = (exec-n-reload-bar "amixer sset Master   15%-");
					"Ctrl+Shift+XF86AudioRaiseVolume" = (exec-n-reload-bar "amixer sset Master  100%+");
					"Ctrl+Shift+XF86AudioLowerVolume" = (exec-n-reload-bar "amixer sset Master  100%-");
							   "XF86AudioMute"        = (exec-n-reload-bar "amixer sset Master toggle");

					# Brightness
							   "XF86MonBrightnessUp"   = (exec-n-reload-bar "sudo backlight inc  5%");
							   "XF86MonBrightnessDown" = (exec-n-reload-bar "sudo backlight dec  5%");
						 "Shift+XF86MonBrightnessUp"   = (exec-n-reload-bar "sudo backlight inc 15%");
						 "Shift+XF86MonBrightnessDown" = (exec-n-reload-bar "sudo backlight dec 15%");
					"Ctrl+Shift+XF86MonBrightnessUp"   = (exec-n-reload-bar "sudo backlight set max");
					"Ctrl+Shift+XF86MonBrightnessDown" = (exec-n-reload-bar "sudo backlight set   0");

					# Media player controls
					# "XF86AudioPlayPause" = (exec "playerctl play-pause");
					"XF86AudioPlay"  = (exec "${pkgs.playerctl}/bin/playerctl play-pause"); # playerctl play
					"XF86AudioPause" = (exec "${pkgs.playerctl}/bin/playerctl play-pause"); # playerctl pause
					"XF86AudioStop"  = (exec "${pkgs.playerctl}/bin/playerctl stop");
					"XF86AudioPrev"  = (exec "${pkgs.playerctl}/bin/playerctl previous");
					"XF86AudioNext"  = (exec "${pkgs.playerctl}/bin/playerctl next");


					# Revised default controls

					"${mod}+Shift+q" = "kill";       # kill focused window
					"${mod}+d"       = (exec "${pkgs.dmenu}/bin/dmenu_run");

					# change focus
					"${mod}+${kl}" = "focus left";
					"${mod}+${kd}" = "focus down";
					"${mod}+${ku}" = "focus up";
					"${mod}+${kr}" = "focus right";

					# move focused window
					"${mod}+Shift+${kl}" = "move left";
					"${mod}+Shift+${kd}" = "move down";
					"${mod}+Shift+${ku}" = "move up";
					"${mod}+Shift+${kr}" = "move right";

					# screen mode
					# "${mod}+h" = "split h"; # hor split
					"${mod}+v" = "split v"; # ver split
					"${mod}+f" = "fullscreen toggle";

					# layout
					"${mod}+s" = "layout stacking";
					"${mod}+w" = "layout tabbed";
					"${mod}+e" = "layout toggle split";

					# floating
					"${mod}+space"       = "focus mode_toggle";
					"${mod}+Shift+space" = "floating toggle";
					"${mod}+a"           = "focus parent";
					"${mod}+Shift+a"     = "focus child";

					# special i3
					"${mod}+Shift+c" = "reload";
					"${mod}+Shift+r" = "restart";
					"${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'";
					"${mod}+r" = "mode resize";
				}
				//
				(
					let
						keyValue = (name: value: { inherit name value; });
					in
					builtins.listToAttrs
					(
						(
							builtins.map
								(workspace: (keyValue "${mod}+${workspace}" "workspace ${workspace}"))
								workspaces
						)
						++
						(
							builtins.map
								(workspace: (keyValue "${mod}+Shift+${workspace}" "move container to workspace ${workspace}"))
								workspaces
						)
					)
				)
				;


				colors =
				let
					get-default = (
						text:
						{
							border = lib.mkForce col.background;
							text   = lib.mkForce (if text != null then text else col.text);
						}
					);

					add-tint = (
						color:
						{
							background  = lib.mkForce color;
							indicator   = lib.mkForce color;
							childBorder = lib.mkForce color;
						}
					);
				in
				{
					background = lib.mkForce (col.background);
					focused         = (get-default null)          // (add-tint col.focused);
					urgent          = (get-default null)          // (add-tint col.error);
					focusedInactive = (get-default col.unfocused) // (add-tint col.alt-background);
					unfocused       = (get-default col.unfocused) // (add-tint col.alt-background);
					placeholder     = (get-default null)          // (add-tint col.background);
				};


				modes.resize =
				{
					"${mod}+${kl}" = "resize shrink width  2 px or 2 ppt";
					"${mod}+${kd}" = "resize shrink height 2 px or 2 ppt";
					"${mod}+${ku}" = "resize grow   height 2 px or 2 ppt";
					"${mod}+${kr}" = "resize grow   width  2 px or 2 ppt";

					# back to normal: Enter or Escape or $mod+r
					"Return"   = "mode default";
					"Escape"   = "mode default";
					"${mod}+r" = "mode default";
				};

				# TODO: add all applications that should startup in floating state
				floating.criteria =
				[
					{ title = "Steam - Update News"; }
					{ class = "Pavucontrol"; }
				];

				bars =
				let
					is-i3status-configured = config.xdg.configFile."i3status/config".text != null;
					i3status-config = pkgs.writeTextFile {
						name = "i3status-config";
						inherit (config.xdg.configFile."i3status/config") text;
					};
				in
				[ {
					fonts = lib.mkForce (i3-cfg.fonts);
					statusCommand = lib.mkIf (is-i3status-configured) "${pkgs.i3status}/bin/i3status -c ${i3status-config}";
					extraConfig = "separator_symbol \"|\"";

					colors =
					let
						default-inactive = {
							border = col.alt-background;
							background = col.alt-background;
							text = col.unfocused;
						};
					in
					{
						background = col.background;
						statusline = col.text;
						separator  = col.unfocused;

						focusedWorkspace = {
							border = col.focused;
							background = col.focused;
							inherit (col) text;
						};
						urgentWorkspace = {
							border = col.error;
							inherit (col) background text;
						};

						activeWorkspace   = default-inactive;
						inactiveWorkspace = default-inactive;
						bindingMode       = default-inactive;
					};
				} ];
			};

			extraConfig = ''
exec --no-startup-id ${pkgs.lightlocker}/bin/light-locker
# exec --no-startup-id xsetroot -solid 262626 # set background to solid color

popup_during_fullscreen all
default_border pixel 2
default_floating_border pixel 2
'';
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.i3 =
	{
		enable = lib.mkEnableOption "i3 tiling window manager custom configuration";
	};
}
