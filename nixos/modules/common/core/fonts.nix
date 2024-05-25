{ pkgs, ... }:

{
	fonts.fonts = [
		(pkgs.callPackage (import ../../unofficial/apple-fonts.nix { }))
		(pkgs.nerdfonts.override { fonts = [ "RobotoMono" ]; })

		pkgs.helvetica-neue-lt-std
		pkgs.roboto-mono
		pkgs.iosevka
	];
}
