{ settings, ... }:

{
	programs.alacritty.enable = true && settings.has_de;
	home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;
}
