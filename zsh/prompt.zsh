# justcoderdev zsh cursor


# ' ~ $ ' cyan tinted
PROMPT=$'%F{8} %~ %B%F{4}$%f%b '

if [[ "${SSH_TTY}" == "$(tty)" ]]; then
	# ' ~ $ ' red tinted
	# PROMPT=$'%F{8} %~ %B%F{1}$%f%b '

	# ' ryuji@quiss ~ $ ' red tinted
	# PROMPT=$'%F{6}%n%F{8}@%F{6}%m%F{8} %~ %B%F{1}$%f%b '

	# ' ryuji@quiss ~ $ ' cyan tinted
	# PROMPT=$'%F{4}%n%F{8}@%F{4}%m%F{8} %~ %B%F{4}$%f%b '

	# ' ryuji@quiss ~ $ ' red tinted
	PROMPT=$'%F{1}%n%F{8}@%F{1}%m%F{8} %~ %B%F{1}$%f%b '
fi

# Enable block cursor in normal mode
cursor_mode() {
	# This snippet comes from https://thevaluable.dev/zsh-install-configure-mouseless/
    # that comes from this other page https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes

    cursor_block='\e[2 q'
    cursor_beam='\e[6 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]];
	then
		echo -ne $cursor_block
        elif
		[[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
        	[[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]];
	then
            echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode

