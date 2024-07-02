function github() {
	path="/home/${USER}/Developer/Github/"

	if [ -t 1 ]; then
		cd "${path}"
	else
		echo "${path}"
	fi
}

function projects() {
	path"/home/${USER}/Developer/Projects/"

	if [ -t 1 ]; then
		cd "${path}"
	else
		echo "${path}"
	fi
}

function dotfiles() {
	path="${DOT_FILES}"

	if [ -t 1 ]; then
		cd "${path}"
	else
		echo "${path}"
	fi
}
