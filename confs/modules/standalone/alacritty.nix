# Alacritty config from jdah, thanks man <3
# source <https://github.com/jdah/dotfiles>

{ config, lib, ... }:

let
	inherit (config.jcconfs.host) has-de;

	cfg = config.jcconfs.module.alacritty;
in

{
	config = lib.mkIf (cfg.enable && has-de)
	{
		programs.alacritty =
		{
			enable = true;
			settings =
			{
				general.live_config_reload = false;

				colors =
				{
					draw_bold_text_with_bright_colors = false;

					# primary = {
					# 	background = normal.black;
					# 	foreground = normal.white;
					# };
					#
					# cursor = {
					# 	cursor = normal.white;
					# 	text = normal.black;
					# };
					#
					# normal = {
					# 	red = "#fb4934";
					# 	# orange
					# 	yellow = "#fabd2f";
					# 	green = "#b8bb26";
					# 	cyan = "#8ec07c";
					# 	blue = "#83a598";
					# 	magenta = "#d3869b";
					# 	# brown
					#
					# 	black = "#1d2021";
					# 	white = "#d5c4a1";
					# };
				};

				font = {
					italic.style = "Medium Italic";
					normal.style = lib.mkForce "Medium";
				};

				keyboard.bindings =
				let
					add-char-bind = (
						chars: key: mods:
						{ inherit chars key mods; }
					);
					add-action-bind = (
						action: key: mods:
						{ inherit action key mods; }
					);
				in
				[
					# (add-char-bind "\\u001BF" "Right" "Alt")
					# (add-char-bind "\\u001BB" "Left"  "Alt")

					(add-action-bind "Copy"  "Y" "Shift|Alt")
					(add-action-bind "Paste" "P" "Shift|Alt")
				];

				scrolling.history = 100000;

				terminal.shell = {
					program = "/usr/bin/env";
					args = ["zsh"];
				};

				window =
				{
					dynamic_title = false;
					title = "Terminal";
				};
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.alacritty =
	{
		enable = lib.mkEnableOption "alacritty terminal emulator custom configuration";
	};
}
