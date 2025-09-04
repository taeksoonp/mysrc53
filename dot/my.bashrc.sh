# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig
#놀랬다. export LD_LIBRARY_PATH=LD_LIBRARY_PATH:/usr/local/lib64

alias l='ls -lF --color=tty --time-style=long-iso'
alias bank="cd ~/prj/bank"

#
# git 설정
#
# https://gist.github.com/justintv/168835
# https://www.howtogeek.com/307701/how-to-customize-and-colorize-your-bash-prompt/
# 문법: \[\033[NNm\] 또는 \[\e[NNm\], 속성M 0:normal 1:bold or light \[\e[M;NNm\]
# 색: https://m.blog.naver.com/occidere/220942130602

#노란색 눈부시다	export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\] \[\033[33;1m\]\w\[\033[36m\](\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))\[\033[m\] "
#	export PS1='\w] '
#녹색/파랑 export PS1="\[\033[32m\]\w\[\033[36m\](\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))\[\033[m\] "
#MSYS2 기본 개나리색 \[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[35m\]$MSYSTEM\[\e[0m\] \[\e[33m\]\w\[\e[0m\]\n\$
export PS1="\[\e[33m\]\w\[\e[1;36m\](\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))\[\033[m\] "

source /usr/local/vcpkg/scripts/vcpkg_completion.bash

#etc
export SVN_EDITOR=emacs
alias mysrc='cd ~/GitHub/mysrc53'
alias prj='cd ~/prj'
alias prjbin='cd ~/prj/bin'
alias prjwork='cd ~/prj/work'
alias dt='cd ~/prj/dvrtop'
. $HOME/.hidvr.aliases

#ssh agent
if pgrep -u $USER ssh-agent; then
	. ~/.ssh/ssh-add-latest
else
	ssh-agent > ~/.ssh/ssh-add-latest
	sed 's/echo/#echo/g' -i ~/.ssh/ssh-add-latest
	. ~/.ssh/ssh-add-latest
	ssh-add
fi
