{ pkgs, lib, buildPythonPackage, fetchFromGitHub, git, npm, pip }:

let
	frontend-version = "a8d4db307113aace1c6648008e2cafd336b9a6c7";

	frontend-src = fetchFromGitHub {
		owner = "Unmanic";
		repo = "unmanic-frontend";
		rev = frontend-version;
		sha256 = "sha256-vDbP2Zd5cmQWvp0vjrUKnhbaB0ypEZvz77cFSVu8BLI=";
	};

	frontend-pkg = pkgs.buildNpmPackage {
		pname = "unmanic-frontend";
		version = "a8d4db307113aace1c6648008e2cafd336b9a6c7";
		src = frontend-src;
		npmDepsHash = "sha256-BjF2gKv8Ty4Bhc//nR7ecS0/Mdctm8/WOiRhFn+dEHc=";
	};
in

buildPythonPackage
rec {
	pname = "unmaniac";
	version = "0.3.0";

	src = fetchFromGitHub {
		owner = "Unmanic";
		repo = "unmanic";
		rev = version;
		sha256 = "sha256-m699p4g/dKR7q3nVI83ZvBDUkfvw7rlYyApzwlvVdw4=";
	};

	nativeBuildInputs = [ git npm pip ];
	postPatch = ''
echo '{"short": "3", "long": "0"}' > unmanic/version

cp -r ${frontend-pkg} unmanic/webserver/frontend

mkdir -p unmanic/webserver/frontend/build
cp -r ${frontend-src} unmanic/webserver/frontend/build
'';

	# doCheck = false;
	propagatedBuildInputs = with pkgs.python313Packages; [
		schedule tornado marshmallow peewee # peewee_migrate
		psutil requests requests_toolbelt py-cpuinfo #JSON-log-formatter
		watchdog inquirer # swagger-ui-py
	];

	meta = with lib; {
		description = "Unmanic is a simple tool for optimising your file library. You can use it to convert your files into a single, uniform format, manage file movements based on timestamps, or execute custom commands against a file based on its file size.";
		homepage = "https://github.com/Unmanic/unmanic/";
		license = licenses.gpl3;
	};
}

