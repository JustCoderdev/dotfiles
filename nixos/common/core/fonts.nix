{ pkgs, ... }:

{
	fonts = {
		packages = with pkgs; [
			(callPackage  ../../unofficial/apple-fonts.nix {})
			helvetica-neue-lt-std

			# Mono fonts
			nerd-fonts.roboto-mono
			roboto-mono
			iosevka

			# JPN fonts
			ipaexfont
			kochi-substitute
		];

		# setting up japanese support
		# <https://functor.tokyo/blog/2018-10-01-japanese-on-nixos>
		fontconfig.defaultFonts = {
			monospace = [
				"DejaVu Sans Mono"
				"IPAGothic"
			];
			sansSerif = [
				"DejaVu Sans"
				"IPAPGothic"
			];
			serif = [
				"DejaVu Serif"
				"IPAPMincho"
			];
		};
	};
}
