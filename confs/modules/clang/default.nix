{ config, pkgs, ... }:

let
	available-in-profile = "develop-environment";

	profile-enabled = lib.lists.any
		(profile: profile == available-in-profile)
		config.jcconfs.profiles;
in

{
	home.packages = lib.mkIf (profile-enabled)
	(
		with pkgs; [ clang-tools clang ]
	);

	home.file = lib.mkIf (profile-enabled)
	{
		".clang-format".source = ./.clang-format;
		".config/clang/compile_commands.json".source = ./compile_commands.json;
		".config/clang/config.yaml".source = ./config.yaml;
	};
}
