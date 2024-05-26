{ pkgs, ... }:

{
	fonts.packages = [
		(pkgs.callPackage  ../../unofficial/apple-fonts.nix {})
		(pkgs.nerdfonts.override { fonts = [ "RobotoMono" ]; })

		pkgs.helvetica-neue-lt-std
		pkgs.roboto-mono
		pkgs.iosevka
	];
}
