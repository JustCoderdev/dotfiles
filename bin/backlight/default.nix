{ stdenv, gcc }:

stdenv.mkDerivation
{
	name = "backlight";
	version = "1.0";
	src = ./.;

	# Compilation - Runtime dependencies
	nativeBuildInputs = [ gcc ];
	buildInputs = [ ];
	
	buildPhase = '' ./build.sh '';

	installPhase = ''
mkdir -p $out/bin
cp backlight $out/bin
'';
}
