# justcoderdev zsh cursor

# PROMPT=$'%F{white}%~ %B%F{blue}>%f%b '
PROMPT=$' %F{grey}%~ %B%F{white}$%f%b '

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
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]] ||
            [[ $1 = 'beam' ]];
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

# cursor_mode

