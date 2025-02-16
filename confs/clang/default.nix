{ pkgs, ... }:

{
	# Configuration for:
	#  - clangd
	#  - clang-format

	home.packages = with pkgs; [
		clang-tools
		clang
	];

	home.file = {
		".clang-format".source = ./.clang-format;
		".config/clang" = {
			source = ./.;
			recursive = true;
		};
	};
}
