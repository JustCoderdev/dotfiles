{ pkgs }:

pkgs.mkShell {
	nativeBuildInputs = with pkgs; [
		glibcInfo
		glibc

		clang-tools
		clang

		gnumake
		gdb

		file
	];
	shellHook = ''
		echo -e "\033[34mAccessing C shell\033[0m"
		zsh
	'';
#LD_LIBRARY_PATH = "${makeLibraryPath buildInputs}:${LD_LIBRARY_PATH}";
}
