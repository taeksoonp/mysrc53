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

#pc용 git이랑 모드 일치시킬라고. 안하면 디폴티 0002
umask 0022

#source scl_source enable devtoolset-11
#source scl_source enable devtoolset-8
#? export LD_LIBRARY_PATH=/opt/boost/lib

#etc
export SVN_EDITOR=emacs
export EMACS_SERVER_FILE=~/etc/server/server
export TERM=xterm-256color
export Ga_hih="[가-힣]"
alias mysrc='cd ~/GitHub/mysrc53'
alias prj='cd ~/prj'
alias prjbin='cd ~/prj/bin'
alias prjwork='cd ~/prj/work'
alias ddtt='cd ~/prj/dvrtop'
. $HOME/.hidvr.aliases

# https://gist.github.com/justintv/168835
export LS_COLORS="di=00;36:fi=00;37"

source $HOME/vcpkg/scripts/vcpkg_completion.bash
# ssh-agent https://gist.github.com/nepsilon/45fae11f8d173e3370c3
source $HOME/.ssh/ssh-agent-latest
source $HOME/bash-completion/ct-ng

#죽겄네
export WHBS_OEM_ID_LIST_CFLAGS="-DWEBGATE=0 -DSONE=1"
. "$HOME/.cargo/env"
