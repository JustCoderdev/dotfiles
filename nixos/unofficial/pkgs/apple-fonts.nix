# Derivation based on the one from robbins, thanks <3 (had to update hashes)
# source <https://gist.github.com/robbins/dccf1238e971973a6a963b04c486c099>
# font sources <https://codeberg.org/adamcstephens/apple-fonts.nix/src/branch/main/sources.nix>

{
	lib,
	stdenv,
	fetchurl,
	p7zip
}:

let
	build-font =
	(
		name: hash:
		let
			lower-name   = lib.strings.toLower name;
			compact-name = builtins.replaceStrings [ "-" ] [ "" ]  name;
			human-name   = builtins.replaceStrings [ "-" ] [ " " ] name;
			package = fetchurl {
				url = "https://devimages-cdn.apple.com/design/resources/download/${name}.dmg";
				inherit hash;
			};
		in
		stdenv.mkDerivation
		{
			name = "apple-font-${lower-name}";
			version = "1";

			sourceRoot = ".";
			dontUnpack = true;
			nativeBuildInputs = [ p7zip ];

			installPhase = ''
7z x ${package}
cd ${compact-name}Fonts
7z x '${human-name} Fonts.pkg'
7z x 'Payload~'
mkdir -p $out/fontfiles
mv Library/Fonts/* $out/fontfiles

mkdir -p $out/usr/share/fonts/OTF $out/usr/share/fonts/TTF
mv $out/fontfiles/*.otf $out/usr/share/fonts/OTF
mv $out/fontfiles/*.ttf $out/usr/share/fonts/TTF
rm -rf $out/fontfiles
'';

			meta = {
				description = "Apple San Francisco, ${human-name} Font";
				homepage = "https://developer.apple.com/fonts/";
				license = lib.licenses.unfree;
			};
		}
	);
in
{
	sf-pro     = (build-font "SF-Pro"     "sha256-W0sZkipBtrduInk0oocbFAXX1qy0Z+yk2xUyFfDWx4s=");
	sf-compact = (build-font "SF-Compact" "sha256-RWeq4GFt01r8NLrWvvVH5y/R5lhFMFozlzBkUY0dU0g=");
	sf-mono    = (build-font "SF-Mono"    "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=");
	ny         = (build-font "NY"         "sha256-HC7ttFJswPMm+Lfql49aQzdWR2osjFYHJTdgjtuI+PQ=");
}
