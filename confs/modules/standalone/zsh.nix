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

			sessionVariables =
			{
				DOT_NIXOS = 1;
				DOT_FILES ="/home/\${USER}/.config/dotfiles";
			};

			history =
			{
				append = true;
				saveNoDups = true;
				share = true;
			};

			setOptions =
			[
				"AUTO_LIST"          # Automatically list choices on ambiguous completion
				"AUTO_MENU"          # Start completition by pressing the tab key repeatedly

				"AUTO_PARAM_SLASH"   # Add a trailing slash instead of a space
				"AUTO_REMOVE_SLASH"  # Remove trailing slash after delimiter

				"COMPLETE_ALIASES"   # Complete aliases
				"COMPLETE_IN_WORD"   # Complete from both ends of a word

				"LIST_PACKED"        # Make completition list smaller
				"LIST_ROWS_FIRST"    # Lay out the matches in completion lists sorted horizontally

				"NO_MENU_COMPLETE"   # Automatically highlight first element of completion menu
			];

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
				"fgdeb" = "'echo -e \" \\033[30m[0:BLK] \\033[31m[1:RED] \\033[32m[2:GRN] \\033[33m[3:YLW] \\033[34m[4:BLU] \\033[35m[5:MAG] \\033[36m[6:CYN] \\033[37m[7:WHT]\"'";
				"fgbrdeb" = "'echo -e \" \\033[90m[0:GRY] \\033[91m[1:RED] \\033[92m[2:GRN] \\033[93m[3:YLW] \\033[94m[4:BLU] \\033[95m[5:MAG] \\033[96m[6:CYN] \\033[97m[7:WHT]\"'";

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

			syntaxHighlighting =
			{
				enable = true;
				highlighters = [ "brackets" ];

				# Complete styles list <https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md>
				styles =
				(
					builtins.listToAttrs
					(
						builtins.map
						(
							name:
							{
								inherit name;
								value = "none";
							}
						)
						[
							# main
							"reserved-word" "alias" "suffix-alias" "global-alias" "builtin" "function" "command" "precommand" "commandseparator" "hashed-command" "autodirectory" "path" "path_pathseparator" "path_prefix" "path_prefix_pathseparator" "globbing" "history-expansion" "command-substitution" "command-substitution-unquoted" "command-substitution-quoted" "command-substitution-delimiter" "command-substitution-delimiter-unquoted" "command-substitution-delimiter-quoted" "process-substitution" "process-substitution-delimiter" "arithmetic-expansion" "single-hyphen-option" "double-hyphen-option" "back-quoted-argument" "back-quoted-argument-unclosed" "back-quoted-argument-delimiter" "single-quoted-argument" "single-quoted-argument-unclosed" "double-quoted-argument" "double-quoted-argument-unclosed" "dollar-quoted-argument" "dollar-quoted-argument-unclosed" "rc-quote" "dollar-double-quoted-argument" "back-double-quoted-argument" "back-dollar-quoted-argument" "assign" "redirection" "comment" "comment" "named-fd" "numeric-fd" "arg0" "default"

							# brackets
							"bracket-level-1" "bracket-level-2" "bracket-level-3" "bracket-level-4" "bracket-level-5"
						]
					)
				);
			};

			initContent = ''
## Options
zstyle ':completion:*' cache-path "/home/''${USER}/.cache/zcompcache"
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select

## Style
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'

zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

zstyle ':completion:*' group-name '''
''
+
''
# Enable truecolor for alacritty
# if [[ "''${TERM}" == "alacritty" ]]; then
	COLORTERM="truecolor"
	LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:"
# fi

# Check if we're in an ssh tty
if [[ "''${SSH_TTY}" == "$(tty)" ]]; then
	# ' ryuji@quiss ~ $ ' red tinted
	PROMPT=$'%F{1}%n%F{8}@%F{1}%m%F{8} %~ %B%F{1}$%f%b '

	# Show subshell lvl
	if [[ "''${SHLVL}" > 1 ]]; then
		# ' ryuji@quiss ~ $ ' magenta tinted
		PROMPT="%F{5}%n%F{8}@%F{5}%m%F{8} %~ %B%F{5}\$''${SHLVL}%f%b "
	fi
fi

# Set fallback prompt
if [[ "''${PROMPT}" == '%n@%m:%~/ > ' || "''${PROMPT}" == '%m%# ' ]];
then
	# ' ~ $ ' cyan tinted
	PROMPT=$'%F{8} %~ %B%F{6}$%f%b '

	# Show subshell lvl
	if [[ "''${SHLVL}" > 1 ]]; then
		# ' ~ $ ' magenta tinted
		PROMPT="%F{8} %~ %B%F{5}\$''${SHLVL}%f%b "
	fi
fi
''
+
''
# Enable block cursor in normal mode
# This snippet comes from https://thevaluable.dev/zsh-install-configure-mouseless/
# that comes from this other page https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes

cursor_block='\e[2 q'
cursor_beam='\e[6 q'

function zle-keymap-select {
	if [[ ''${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]];
then
	echo -ne $cursor_block
	elif
	[[ ''${KEYMAP} == main ]] || [[ ''${KEYMAP} == viins ]] ||
		[[ ''${KEYMAP} = ''' ]] || [[ $1 = 'beam' ]];
then
		echo -ne $cursor_beam
	fi
}

zle-line-init() {
	echo -ne $cursor_beam
}

zle -N zle-keymap-select
zle -N zle-line-init
'';
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.zsh =
	{
		enable = lib.mkEnableOption "zsh shell custom configuration";
	};
}
