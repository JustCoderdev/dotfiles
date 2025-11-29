{ config, lib, ... }:

let
	cfg = config.jcconfs.module.zsh;
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs.zsh =
		{
			enable = true;
			completionInit = "";

			initContent = ''
export DOT_NIXOS=1;
export DOT_FILES="/home/''${USER}/.config/dotfiles"
source "''${DOT_FILES}/confs/modules/zsh/.zshrc"
'';
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.zsh =
	{
		enable = lib.mkEnableOption "zsh shell custom configuration";
	};
}
