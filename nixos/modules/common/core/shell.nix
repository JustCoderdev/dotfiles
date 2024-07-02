{ pkgs, ... }:

#let
#	build-script = { name, path }:
#		pkgs.writeShellApplication {
#			inherit name;
#			text = ''
#if [ -t 1 ]; then
#	cd "${path}"
#fi
#
#echo "${path}"
#'';
#	};
#in

{
	# Path completition
#	environment.systemPackages = [
#		(build-script {
#			name = "github";
#			path = "/home/\${USER}/Developer/Github/";
#		})
#		(build-script {
#			name = "projects";
#			path = "/home/\${USER}/Developer/Projects/";
#		})
#		(build-script {
#			name = "dotfiles";
#			path = "\$DOT_FILES";
#		})
#	];


	# Use zsh as shell
	programs.zsh = {
		enable = true;
		enableGlobalCompInit = false;
	};

	environment.shells = [ pkgs.zsh ];
	users.defaultUserShell = pkgs.zsh;
}
