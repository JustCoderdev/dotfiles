# Derivation from robbins, thanks <3 (had to update hashes)
# source <https://gist.github.com/robbins/dccf1238e971973a6a963b04c486c099>

{ lib, stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
	name = "apple-fonts";
	version = "1";

	pro = fetchurl {
		url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
		sha256 = "";
	};

	compact = fetchurl {
		url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
		sha256 = "";
	};

	mono = fetchurl {
		url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
		sha256 = "";
	};

	ny = fetchurl {
		url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
		sha256 = "";
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
