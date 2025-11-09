{ settings, ... }:

let
	inherit (settings) has-de;
in

{
	programs.alacritty.enable = true && has-de;
	home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;
}
