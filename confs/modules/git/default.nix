{ ... }:

{
	programs.git.enable = true;

	home.file = {
		".gitconfig".source = ./.gitconfig;
		".gitignore_global".source = ./.gitignore_global;
	};
}
