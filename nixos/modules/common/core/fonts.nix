{ pkgs, ... }:

{
	fonts.fonts = with pkgs; [
		roboto-mono
		iosevka
	];
}
