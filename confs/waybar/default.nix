{ ... }:

{
	programs.waybar.enable = true;

	home.file.".config/waybar" = {
		source = ./.;
		recursive = true;
	};
}
