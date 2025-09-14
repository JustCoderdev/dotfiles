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
	version = "1.0.4";

	src = fetchFromGitHub {
		owner = "neXromancers";
		repo = "hacksaw";
		rev = "115bb30c870ff19a03a0a101e145ad8a822193e2";
		hash = "0ncyr0rw9f4bnvxcq6i8vkgj0ixg060inrssbwz4y3nq9nakbp61";
	};

	nativeBuildInputs = [ cargo python3 ]; # pkgconfig
	buildInputs = [ libX11 libXrandr libxcb ];

	installPhase = ''
cargo install --path .
mkdir -p $out/bin
mv target/release/hacksaw $out/bin
'';

	meta = with lib; {
		description = "Lets you select areas of your screen (on X11)";
		homepage = "https://github.com/neXromancers/hacksaw";
		license = licenses.mpl20;
		maintainers = with maintainers; [ bb010g ];
		platforms = platforms.unix;
	};
}

