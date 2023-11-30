#!/bin/bash

__kube_ps1() {
	if [ -f ~/.kube/config ] ; then
		CONTEXT=$(cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //")

		if [ -n "$CONTEXT" ] ; then
			echo "(k8s: ${CONTEXT})"
		fi
	fi
}

NORMAL="\[\033[00m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\e[1;33m\]"
GREEN="\[\e[1;32m\]"

export PS1="${GREEN}\u@\h:${BLUE}\w ${YELLOW}\$(__kube_ps1) \$(GIT_PS1_SHOWDIRTYSTATE=true __git_ps1 '(git: %s)')${NORMAL} \n\$ "

