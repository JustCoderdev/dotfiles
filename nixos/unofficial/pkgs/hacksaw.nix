# A rewrite of the derivation for hacksaw
# Source <https://github.com/neXromancers/nixromancers/blob/master/pkgs/tools/misc/hacksaw/generic.nix>

{
	lib, stdenv, fetchFromGitHub, callPackage, # pkgconfig,
	cargo, python3, libxcb,    # native build inputs
	libX11, libXrandr  # build inputs
}:

stdenv.mkDerivation
rec {
	name = "hacksaw";
	version = "fd6b6bd1be435dd546e7efd0ed8800623bb098fa";

	src = fetchFromGitHub {
		owner = "neXromancers";
		repo = "hacksaw";
		rev = version;
		hash = "";
	};

	nativeBuildInputs = [ cargo python3 libxcb ]; # pkgconfig
	buildInputs = [ libX11 libXrandr libxcb ];

	installPhase = ''
cargo install --path .
pwd
# mkdir -p $out/bin
# mv Library/Fonts/* $out/fontfiles
'';

	meta = with lib; {
		description = "Lets you select areas of your screen (on X11)";
		homepage = "https://github.com/neXromancers/hacksaw";
		license = licenses.mpl20;
		maintainers = with maintainers; [ bb010g ];
		platforms = platforms.unix;
	};
}

