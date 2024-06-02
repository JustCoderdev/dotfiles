{ pkgs, ... }:

{
	# Use zsh as shell
	programs.zsh = {
		enable = true;
		enableGlobalCompInit = false;
	};

	environment.shells = [ pkgs.zsh ];
	users.defaultUserShell = pkgs.zsh;
}
