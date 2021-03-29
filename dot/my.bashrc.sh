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
export PATH=~/.local/bin:$PATH:/opt/hisi-linux/x86-arm/arm-hisiv200-linux/target/bin:/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/bin::/opt/hisi-linux/x86-arm/arm-hisiv600-linux/target/bin:/opt/ivot/arm-ca9-linux-gnueabihf-6.5/usr/bin

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

#echo "gcc8 쓴다."
#source scl_source enable devtoolset-4
source scl_source enable devtoolset-8

#etc
export SVN_EDITOR=emacs
export EMACS_SERVER_FILE=~/etc/server/server
export TERM=xterm-256color
export Ga_hih="[가-힣]"
alias euckr='export LANG=ko_KR.euckr'
alias mysrc='cd ~/github/mysrc53'
alias github='cd ~/github'
alias prj='cd ~/prj'
alias prjbin='cd ~/prj/bin'
alias prjwork='cd ~/prj/work'
alias prjtmp='cd ~/prj/tmp'
alias prjtt='cd ~/prj/tests64'
alias prjqt='cd ~/prj/qt5trunk'
alias sdb='cd ~/prj/sdb1'

#hidvr
. .hidvr.aliases

#rust
#. .cargo/env

# https://gist.github.com/justintv/168835
export LS_COLORS="di=00;36:fi=00;37"
