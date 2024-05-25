{ pkgs, ... }:

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
}
