function github() {
	if [ -t 1 ]; then
		cd "/home/${USER}/Developer/Github/"
	else
		echo "/home/${USER}/Developer/Github/"
	fi
}

function projects() {
	if [ -t 1 ]; then
		cd "/home/${USER}/Developer/Projects/"
	else
		echo "/home/${USER}/Developer/Projects/"
	fi
}

function dotfiles() {
	if [ -t 1 ]; then
		cd "${DOT_FILES}"
	else
		echo "${DOT_FILES}"
	fi
}
