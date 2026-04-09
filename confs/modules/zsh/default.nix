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

			shellAliases =
			{
				ez ="echo 'Updating zsh'; exec zsh";
				rm ="rm -vI";

				ls = "ls --color -F";
				la = "ls -Fa";
				ll = "ls -Flah";
				cls ="clear && ls";
				cl = "cls";
				sls = "ls";
				l = "ls";
				scls = "cls";
				sl = "ls";

				".." = "cd ..";
				"..." = "cd ../..";
				"...." = "cd ../../..";
				"....." = "cd ../../../..";

				# Save Directory
				"sd" = "'echo $(pwd) > \"/home/$USER/.zsh/sd\" && cat \"/home/$USER/.zsh/sd\"'";
				"sdl" = "'cd $(cat \"/home/$USER/.zsh/sd\")'";

				# Debug
				"fgdeb" = "'echo -e \" \033[30m[0:BLK] \033[31m[1:RED] \033[32m[2:GRN] \033[33m[3:YLW] \033[34m[4:BLU] \033[35m[5:MAG] \033[36m[6:CYN] \033[37m[7:WHT]\"'";
				"fgbrdeb" = "'echo -e \" \033[90m[0:GRY] \033[91m[1:RED] \033[92m[2:GRN] \033[93m[3:YLW] \033[94m[4:BLU] \033[95m[5:MAG] \033[96m[6:CYN] \033[97m[7:WHT]\"'";

				## git
				"gs" = "git status";
				"gl" = "git log --all --color --decorate --oneline --graph";
				"gd" = "git diff";
				"gdc" = "git diff --cached";
				"gf" = "git fetch";
				"gp" = "git push";
				"ga" = "git add";
				"gc" = "git commit";

				# neovim
				"nold" = "nvim -S .old_session.vim";
				"nivm" = "nvim";
			};

			shellGlobalAliases =
			{
				dotfiles = "\${DOT_FILES}";
				projects = "/home/\${USER}/Developer/Projects";
				github   = "/home/\${USER}/Developer/Github";
			};
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.zsh =
	{
		enable = lib.mkEnableOption "zsh shell custom configuration";
	};
}
