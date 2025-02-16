{ ... }:

{
	programs.git.enable = true;

	home.file = {
		".gitconfig".source = ./.gitconfig;
		".gititnore_global".source = ./.gitignore_global;
	};
}
