{ pkgs, lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage
rec {
	pname = "anotherjulien-OWNd";
	version = "0.7.48";

	# format = "pyproject";
	# src = ./OWNd-0.7.49.tar.gz;

	src = fetchFromGitHub {
		owner = "anotherjulien";
		repo = "OWNd";
		rev = "5349c94ed4cfb0f71ea8400454ae1279fe8f6be4";
		sha256 = "sha256-uER77l90dkL3aLrG5rErBzvz5zQldeipmwBytvdrK8I=";
	};

	doCheck = false;
	propagatedBuildInputs = with pkgs.python313Packages; [ aiohttp pytz python-dateutil ];

	postUnpack = ''
ls .;
rm -r source/dist
'';

	meta = with lib; {
		description = "OpenWebNet daemon";
		homepage = "https://github.com/anotherjulien/OWNd";
		license = licenses.lgpl3;
	};
}
