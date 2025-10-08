{ config, lib, settings, ... }:

let
	stylix-cfg = config.stylix;
	col = with stylix-cfg.base16Scheme;
	{
		background = base00;
		alt-background = base01;

		unfocused = base02;
		alt-unfocused = base03;

		alt-text = base04;
		text = base05;

		error = base08;
		urgent = base09;

		focused = base0D;
	};

	ifnull = (
		var: substitute:
		if var == null then substitute else var
	);
in

{
	home.file = {
		# ".config/i3/config".source = ./config;
		".config/i3/i3status.conf".source = ./i3status.conf;
	};

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

			fonts.names = lib.mkForce [ stylix-cfg.fonts.monospace.name ];
			workspaceAutoBackAndForth = true;

			startup =
			let
				add-script = (
					command: workspace: always: notification:
					{ inherit command workspace always notification; }
				);
				add-app = (
					command: workspace:
					(add-script command workspace false false)
				);
			in
			[
				(add-app "alacritty"       "2")
				(add-app "firefox"         "1")
				(add-app "dmenu_path > /tmp/dmenu_binaries" null)
				# (add-script "xsetroot -solid 262626" null true false) # set background to solid color
			];

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
				"${mod}+Ctrl+l"  = (exec "dm-tool lock");
				"${mod}+o"       = (exec "obsidian");

				"${mod}+Z"       = (exec "boomer");
				"${mod}+F4"      = "exec \"i3-nagbar -m 'Click here if you want to shutdown the system' -B 'Shut now' 'shutdown now' -B 'Reboot' 'shutdown -r now' -B 'Cancel' 'shutdown -c'\"";
				"${mod}+Shift+s" = "exec shotgun $(hacksaw -f '-i %i -g %g') \"/home/$USER/Pictures/Screenshots/screenshot_$(date '+%Y-%m-%d_%H:%M:%S').png\"";


				# Various controls
				# Source: <https://faq.i3wm.org/question/3747/enabling-multimedia-keys/?answer=3759#post-id-3759>

				# Pulseaudio
				"XF86AudioRaiseVolume"            = (exec-n-reload-bar "amixer sset Master    5%+");
				"XF86AudioLowerVolume"            = (exec-n-reload-bar "amixer sset Master    5%-");
				"Shift+XF86AudioRaiseVolume"      = (exec-n-reload-bar "amixer sset Master   15%+");
				"Shift+XF86AudioLowerVolume"      = (exec-n-reload-bar "amixer sset Master   15%-");
				"Ctrl+Shift+XF86AudioRaiseVolume" = (exec-n-reload-bar "amixer sset Master  100%+");
				"Ctrl+Shift+XF86AudioLowerVolume" = (exec-n-reload-bar "amixer sset Master  100%-");
				"XF86AudioMute"                   = (exec-n-reload-bar "amixer sset Master toggle");

				# Brightness
				"XF86MonBrightnessUp"              = (exec-n-reload-bar "sudo backlight inc  5%");
				"XF86MonBrightnessDown"            = (exec-n-reload-bar "sudo backlight dec  5%");
				"Shift+XF86MonBrightnessUp"        = (exec-n-reload-bar "sudo backlight inc 15%");
				"Shift+XF86MonBrightnessDown"      = (exec-n-reload-bar "sudo backlight dec 15%");
				"Ctrl+Shift+XF86MonBrightnessUp"   = (exec-n-reload-bar "sudo backlight set max");
				"Ctrl+Shift+XF86MonBrightnessDown" = (exec-n-reload-bar "sudo backlight set   0");

				# Media player controls
				"XF86AudioPlayPause" = (exec "playerctl play-pause");
				"XF86AudioPlay"      = (exec "playerctl play-pause"); # playerctl play
				"XF86AudioPause"     = (exec "playerctl play-pause"); # playerctl pause
				"XF86AudioStop"      = (exec "playerctl stop");
				"XF86AudioPrev"      = (exec "playerctl previous");
				"XF86AudioNext"      = (exec "playerctl next");


				# Revised default controls

				"${mod}+Shift+q" = "kill";       # kill focused window
				"${mod}+d" = (exec "cat /tmp/dmenu_binaries | dmenu -i -p '> ' |  \${SHELL:-'/bin/sh'} &");

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
				builtins.listToAttrs
				(
					(
						builtins.map
						(
							workspace:
							{
								name = "${mod}+${workspace}";
								value = "workspace ${workspace}";
							}
						)
						workspaces
					)
					++
					(
						builtins.map
						(
							workspace:
							{
								name = "${mod}+Shift+${workspace}";
								value = "move container to workspace ${workspace}";
							}
						)
						workspaces
					)
				)
			)
			;


			colors =
			let
				get-default = (
					{ border ? null, text ? null, ... }:
					{
						border = lib.mkForce (ifnull border col.background);
						text   = lib.mkForce (ifnull text   col.text);
					}
				);

				add-tint = (
					color: { background ? null, indicator ? null, childBorder ? null, ... }:
					{
						background  = lib.mkForce (ifnull background  color);
						indicator   = lib.mkForce (ifnull indicator   color);
						childBorder = lib.mkForce (ifnull childBorder color);
					}
				);
			in
			{
				background = lib.mkForce (col.background);
				focused         = (get-default {})                        // (add-tint col.focused        {});
				urgent          = (get-default {})                        // (add-tint col.error          {});
				focusedInactive = (get-default { text = col.unfocused; }) // (add-tint col.alt-background {});
				unfocused       = (get-default { text = col.unfocused; }) // (add-tint col.alt-background {});
				placeholder     = (get-default {})                        // (add-tint col.background     {});
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

			bars = [ {
				fonts = lib.mkForce (i3-cfg.fonts);
				statusCommand = "i3status -c /home/\${USER}/.config/i3/i3status.conf";
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
					separator  = col.background;

					focusedWorkspace = {
						border = col.focused;
						background = col.focused;
						inherit (col) text;
					};
					urgentWorkspace = {
						border = col.urgent;
						inherit (col) background text;
					};

					activeWorkspace = default-inactive;
					inactiveWorkspace = default-inactive;
					bindingMode = default-inactive;
				};
			} ];
		};
	};
}
