# A rewrite of the derivation for hacksaw
# Source <https://github.com/neXromancers/nixromancers/blob/master/pkgs/tools/misc/hacksaw/generic.nix>

{
	lib, stdenv, rustPlatform, fetchFromGitHub,
	python3, libxcb,  # native build inputs       pkg-config,
	libX11, libXrandr  # build inputs
}:

rustPlatform.buildRustPackage
rec {
	name = "hacksaw";
	version = "1.0.4";

	src = fetchFromGitHub {
		owner = "neXromancers";
		repo = "hacksaw";
		rev = "115bb30c870ff19a03a0a101e145ad8a822193e2";
		hash = "sha256-wdw1lU3YDk8+X1pnG4EBr0cg39woGsz6tou4xDPInlk=";
	};

	
	cargoLock = {
		lockFile = ./hacksaw-Cargo.lock;
		outputHashes = { };
	};

	
	postPatch = ''
		# Overwrite cargo.lock because the one in the upstream repo has duplicates entries.
		cp ${cargoLock.lockFile} Cargo.lock
	'';

	nativeBuildInputs = [ python3 ]; # pkg-config
	# buildFeatures = lib.optionals (stdenv.hostPlatform.isLinux) [ "linux-pkg-config" ];
	buildInputs = [ libX11 libXrandr libxcb ];

	meta = with lib; {
		description = "Lets you select areas of your screen (on X11)";
		homepage = "https://github.com/neXromancers/hacksaw";
		license = licenses.mpl20;
		maintainers = with maintainers; [ bb010g ];
		platforms = platforms.unix;
	};
}

