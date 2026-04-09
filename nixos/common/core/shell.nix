{ pkgs, ... }:

{
	programs.zsh.enable = true;
	users.defaultUserShell = pkgs.zsh;
	environment.shells = [ pkgs.zsh ];
	environment.pathsToLink = [ "/share/zsh" ];
}
