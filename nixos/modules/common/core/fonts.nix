{ pkgs, ... }:

{
	fonts.fonts = with pkgs; [
		helvetica-neue-lt-std
		roboto-mono
		iosevka
	];
}
