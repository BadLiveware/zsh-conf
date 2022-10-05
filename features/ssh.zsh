function wrapssh() {
	setopt shwordsplit &>/dev/null

	# load agent if it's not running
	if [ -z "$SSH_AUTH_SOCK" ]; then
		eval $(ssh-agent) &>/dev/null
	fi

	# load keys if necessary
	DO_ADD=0
	LOADED=$(ssh-add -L | awk '{print($3)}')
	for x in $HOME/.ssh/id_rsa $HOME/.ssh/id_dsa $HOME/.ssh/id_ecdsa; do
		if [ -r $x ]; then
			FOUND=0
			for l in $LOADED; do
				if [ "${x}" = "${l}" ]; then
					FOUND=1
				fi
			done
			if [ $FOUND -eq 0 ]; then
				DO_ADD=1
			fi
		fi
	done
	
	if [ $DO_ADD -eq 1 ]; then
		ssh-add 2>/dev/null
	fi
	
	"$@"
}
alias ssh='wrapssh ssh'
alias scp='wrapssh scp'
alias rsync='wrapssh rsync'
