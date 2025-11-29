# Alacritty config from jdah, thanks man <3
# source <https://github.com/jdah/dotfiles>

{ config, lib, ... }:

let
	inherit (config.jcconfs) has-de;

	stylix-cfg = config.stylix;
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

				# jdah color palette
				colors =
				{
					draw_bold_text_with_bright_colors = false;

					primary = {
						background = "0x1d2021";
						foreground = "0xd5c4a1";
					};

					normal = {
						black = "0x1d2021";
						blue = "0x83a598";
						cyan = "0x8ec07c";
						green = "0xb8bb26";
						magenta = "0xd3869b";
						red = "0xfb4934";
						white = "0xd5c4a1";
						yellow = "0xfabd2f";
					};

					bright = {
						black = "0x665c54";
						blue = "0xbdae93";
						cyan = "0xd65d0e";
						green = "0x3c3836";
						magenta = "0xebdbb2";
						red = "0xfe8019";
						white = "0xfbf1c7";
						yellow = "0x504945";
					};

					cursor = {
						cursor = "0xd5c4a1";
						text = "0x1d2021";
					};
				};

				font = {
					italic.style = "Medium Italic";
					size = stylix-cfg.fonts.sizes.terminal;
					normal = {
						family = stylix-cfg.fonts.monospace.name;
						style = "Medium";
					};
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
