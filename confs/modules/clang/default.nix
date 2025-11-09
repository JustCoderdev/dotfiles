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
		".config/clang/compile_commands.json".source = ./compile_commands.json;
		".config/clang/config.yaml".source = ./config.yaml;
	};
}
