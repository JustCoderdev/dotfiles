{ pkgs, ... }:

{
	# Use zsh as shell
	programs.zsh.enable = true;
	environment.shells = [ pkgs.zsh ];
	users.defaultUserShell = pkgs.zsh;
}
