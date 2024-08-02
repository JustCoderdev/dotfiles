function github() {
	if [ -t 1 ]; then
		cd "/home/${USER}/Developer/Github/$1"
	else
		echo "/home/${USER}/Developer/Github/$1"
	fi
}

function projects() {
	if [ -t 1 ]; then
		cd "/home/${USER}/Developer/Projects/$1"
	else
		echo "/home/${USER}/Developer/Projects/$1"
	fi
}

function dotfiles() {
	if [ -t 1 ]; then
		cd "${DOT_FILES}/$1"
	else
		echo "${DOT_FILES}/$1"
	fi
}
