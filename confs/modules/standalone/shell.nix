{ config, lib, ... }:

let
	zsh-cfg = config.jcconfs.module.zsh;
	bash-cfg = config.jcconfs.module.bash;

	dotfiles_path = "/home/\${USER}/.config/dotfiles";
	shellAliases =
	{
		ez  = "echo 'Updating zsh'; exec zsh";
		rm  = "rm -vI";
		mkd = "mkdir -p";

		ls   = "ls --color -F";
		la   = "ls -Fa";
		ll   = "ls -Flah";
		cls  = "clear && ls";
		cl   = "cls";
		sls  = "ls";
		l    = "ls";
		scls = "cls";
		sl   = "ls";

		".."    = "cd ..";
		"..."   = "cd ../..";
		"...."  = "cd ../../..";
		"....." = "cd ../../../..";

		# Save Directory
		sd  = "echo $(pwd) > \"/home/$USER/.sd\" && cat \"/home/$USER/.sd\"";
		sdl = "cd $(cat \"/home/$USER/.sd\")";

		# Debug
		fgdeb = "echo -e \" \\033[30m[0:BLK] \\033[31m[1:RED] \\033[32m[2:GRN] \\033[33m[3:YLW] \\033[34m[4:BLU] \\033[35m[5:MAG] \\033[36m[6:CYN] \\033[37m[7:WHT]\"";
		bgdeb = "echo -e \" \\033[90m[0:GRY] \\033[91m[1:RED] \\033[92m[2:GRN] \\033[93m[3:YLW] \\033[94m[4:BLU] \\033[95m[5:MAG] \\033[96m[6:CYN] \\033[97m[7:WHT]\"";

		## git
		gs  = "git status";
		gl  = "git log --all --color --decorate --oneline --graph";
		gd  = "git diff";
		gdc = "git diff --cached";
		ga  = "git add";
		gc  = "git commit";

		# neovim
		nold = "nvim -S .old_session.vim";
		nivm = "nvim";

		# shortcuts
		dotfiles = '' if [ -t 1 ]; then cd "${dotfiles_path}/$1"; else echo "${dotfiles_path}/$1"; fi '';
	};

	sessionVariables =
	{
		LS_COLORS = "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:";
		VISUAL = "vi";
		PAGER = "less";
	};

	make-prompt-script =
	(
		shell:
''
function set-prompt() {
${
	if shell == "bash"
	then
''
	local name='\u'
	local host='\h'
	local path='\w'
	local symb='\$'

	local clr=$'\[\e[0m\]'
	local gry=$'\[\e[90m\]'
	local red=$'\[\e[31m\]'
	local mag=$'\[\e[35m\]'
	local cyn=$'\[\e[36m\]'
''
	else if shell == "zsh"
	then
''
	local name='%n'
	local host='%m'
	local path='%~'
	local symb='$'

	local clr=$'%f'
	local gry=$'%F{8}'
	local red=$'%F{1}'
	local mag=$'%F{5}'
	local cyn=$'%F{6}'
''
	else abort "unknown shell"
}

	local c1=$mag # nested shell color
	local c2=$gry

	PS1='''

	# TODO: why is tty not found?
	# Check if we're in an ssh tty
	if [[ $SSH_TTY == "$(tty)" ]];
	then
		# check if outside of nested shell
		if [[ $SHLVL == 1 ]]; then c1=$red; fi

		PS1+=$c1$name
		PS1+=$c2'@'
		PS1+=$c1$host
	fi

	# check if outside of nested shell
	if [[ $SHLVL == 1 ]]; then c1=$cyn; fi

	PS1+=$c2' '$path' '
	PS1+=$c1$symb
	if [[ $SHLVL > 1 ]]; then PS1+=$SHLVL; fi

	PS1+=$clr' '
}
set-prompt
''
	);

	write-shortcuts-script =
	let
		dotfiles_path = "/home/\${USER}/.config/dotfiles";
	in
	''
function dotfiles() {
	if [ -t 1 ]; then cd "${dotfiles_path}/$1"; else echo "${dotfiles_path}/$1"; fi
}
export -f dotfiles
'';


in

{
	config =
	{
		programs.bash = lib.mkIf (bash-cfg.enable)
		{
			enable = true;
			enableCompletion = true;

			shellOptions = [
				"cdspell"         # cd correct minor errors
				"direxpand"       # replaces dir names with word expansion on filename completion
				"dirspell"        # correct dir names on word completition
				"dotglob"         # include hidden files in pathname expansion
				"histappend"      # history list is appended
				"progcomp_alias"
			];

			profileExtra = "source ~/.bashrc";
			initExtra = ""
				+ write-shortcuts-script
				+ (make-prompt-script "bash")
				;

			inherit shellAliases;
			sessionVariables = (sessionVariables) // { POSIXLY_CORRECT = ""; };
		};

		# ---------------------------------------- #

		programs.zsh = lib.mkIf (zsh-cfg.enable)
		{
			enable = true;

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

			inherit shellAliases sessionVariables;

			siteFunctions =
			let
				dotfiles_path = "\${DOTFILES}";
			in
			{
				_dotfiles = '' local line ''\n _arguments -C "1:: :_path_files -W ${dotfiles_path}" '';
				dotfiles = '' if [ -t 1 ]; then cd "${dotfiles_path}/$1"; else echo "${dotfiles_path}/$1"; fi '';
			};

			syntaxHighlighting =
			{
				enable = true;
				highlighters = [ "brackets" ];

				# Complete styles list <https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md>
				styles = builtins.listToAttrs
				(
					builtins.map (name: { inherit name; value = "none"; })
					[
						# main
						"reserved-word" "alias" "suffix-alias" "global-alias" "builtin" "function" "command" "precommand" "commandseparator" "hashed-command" "autodirectory" "path" "path_pathseparator" "path_prefix" "path_prefix_pathseparator" "globbing" "history-expansion" "command-substitution" "command-substitution-unquoted" "command-substitution-quoted" "command-substitution-delimiter" "command-substitution-delimiter-unquoted" "command-substitution-delimiter-quoted" "process-substitution" "process-substitution-delimiter" "arithmetic-expansion" "single-hyphen-option" "double-hyphen-option" "back-quoted-argument" "back-quoted-argument-unclosed" "back-quoted-argument-delimiter" "single-quoted-argument" "single-quoted-argument-unclosed" "double-quoted-argument" "double-quoted-argument-unclosed" "dollar-quoted-argument" "dollar-quoted-argument-unclosed" "rc-quote" "dollar-double-quoted-argument" "back-double-quoted-argument" "back-dollar-quoted-argument" "assign" "redirection" "comment" "comment" "named-fd" "numeric-fd" "arg0" "default"

						# brackets
						"bracket-level-1" "bracket-level-2" "bracket-level-3" "bracket-level-4" "bracket-level-5"
					]
				);
			};

			initContent =
			let
				comp_style = ''
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
'';

					vi_mode = ''
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

				comp_funcs = ''
#compdef _dotfiles dotfiles
#compdef _projects projects
#compdef _github   github
'';
			in
			lib.mkMerge
			[
				(lib.mkOrder 1000 (make-prompt-script "zsh"))
				(lib.mkOrder 1000 vi_mode)
				(lib.mkOrder 1000 comp_style)
				# 1100: aliases
				(lib.mkOrder 1200 comp_funcs)
				# 1200: highlighting
			];
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module =
	{
		zsh.enable  = lib.mkEnableOption "zsh shell custom configuration";
		bash.enable = lib.mkEnableOption "bash shell custom configuration";
	};
}

