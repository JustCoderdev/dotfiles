# Derivation from robbins, thanks <3 (had to update hashes)
# source <https://gist.github.com/robbins/dccf1238e971973a6a963b04c486c099>
# font sources <https://codeberg.org/adamcstephens/apple-fonts.nix/src/branch/main/sources.nix>

{ lib, stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
	name = "apple-fonts";
	version = "1";

	pro = fetchurl {
		url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
		hash = "sha256-IccB0uWWfPCidHYX6sAusuEZX906dVYo8IaqeX7/O88=";
	};

	compact = fetchurl {
		url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
		hash = "sha256-PlraM6SwH8sTxnVBo6Lqt9B6tAZDC//VCPwr/PNcnlk=";
	};

	mono = fetchurl {
		url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
		hash = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
	};

	ny = fetchurl {
		url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
		hash = "sha256-HC7ttFJswPMm+Lfql49aQzdWR2osjFYHJTdgjtuI+PQ=";
	};

	sourceRoot = ".";
	dontUnpack = true;
	nativeBuildInputs = [ p7zip ];

	installPhase = ''
		7z x ${pro}
		cd SFProFonts
		7z x 'SF Pro Fonts.pkg'
		7z x 'Payload~'
		mkdir -p $out/fontfiles
		mv Library/Fonts/* $out/fontfiles
		cd ..

		7z x ${mono}
		cd SFMonoFonts
		7z x 'SF Mono Fonts.pkg'
		7z x 'Payload~'
		mv Library/Fonts/* $out/fontfiles
		cd ..

		7z x ${compact}
		cd SFCompactFonts
		7z x 'SF Compact Fonts.pkg'
		7z x 'Payload~'
		mv Library/Fonts/* $out/fontfiles
		cd ..

		7z x ${ny}
		cd NYFonts
		7z x 'NY Fonts.pkg'
		7z x 'Payload~'
		mv Library/Fonts/* $out/fontfiles

		mkdir -p $out/usr/share/fonts/OTF $out/usr/share/fonts/TTF
		mv $out/fontfiles/*.otf $out/usr/share/fonts/OTF
		mv $out/fontfiles/*.ttf $out/usr/share/fonts/TTF
		rm -rf $out/fontfiles
	'';

	meta = {
		description = "Apple San Francisco, New York fonts";
		homepage = "https://developer.apple.com/fonts/";
		license = lib.licenses.unfree;
	};
}
