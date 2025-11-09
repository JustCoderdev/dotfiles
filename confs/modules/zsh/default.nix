{ settings, ... }:

let
	inherit (settings) dotfiles_abs_path;
in

{
	programs.zsh =
	{
		enable = true;
		completionInit = "";

		initContent = ''
export DOT_NIXOS=1;
export DOT_FILES='${dotfiles_abs_path}'
source "''${DOT_FILES}/confs/modules/zsh/.zshrc"
'';
	};
}
