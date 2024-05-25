{ pkgs, ... }:

pkgs.mkShell {
	inputsFrom = with pkgs; [default];
	packages = with pkgs; [
		glibcInfo
		glibc

		clang-tools
		clang

		gnumake
		gdb

		file
	];
}
