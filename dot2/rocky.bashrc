# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

#ssh agent
if pgrep -u $USER ssh-agent; then
	. ~/.ssh/ssh-add-latest
else
	ssh-agent > ~/.ssh/ssh-add-latest
	sed 's/echo/#echo/g' -i ~/.ssh/ssh-add-latest
	. ~/.ssh/ssh-add-latest
#pengwin 9.6이후로 안됨	ssh-add
	echo "wns 실행할 거면 resolv.con에 'nameserver 127.0.0.1' 맨 위에 써라"
fi
if [ "`ssh-add -L`" = "The agent has no identities." ]; then
	echo "ssh-add 해라"
fi

#etc
alias ll='ls -alF --time-style=long-iso' la='ls -A' l='ls -CF'
My_gcc_toolset=gcc-toolset-14 #scl list-collections
alias mmake='scl enable '$My_gcc_toolset' make'
export EDITOR=emacs

function findcc ()
{
    if [ $# -eq 0 ]; then
        echo "Usage: findcc [path] <pattern>";
        echo "Tip: If you want space in pattern, you can do it like this 'findcc abc\sxyz'";
        return;
    else
        if [ $# -gt 1 ]; then
            Path=$1;
            Target=$2;
        else
            Path=.;
            Target=$1;
        fi;
    fi;
    find $Path -type f \( -name \*.[hc] -o -name \*.[hc]pp \) -exec egrep -nH $Target {} \;
}

#wsl path
export WslPrefix='\\wsl.localhost\PengwinEnterprise9'

#
# git 설정
#
#https://gist.github.com/justintv/168835
#문법: \[\033[NNm\] 또는 \[\e[NNm\], 속성M 0:normal 1:bold or light \[\e[M;NNm\]
#색: https://m.blog.naver.com/occidere/220942130602

#노란색 눈부시다        export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\] \[\033[33;1m\]\w\[\033[36m\](\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))\[\033[m\] "
#       export PS1='\w] '
#녹색/파랑 export PS1="\[\033[32m\]\w\[\033[36m\](\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))\[\033[m\] "
#MSYS2 기본 개나리색 \[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[35m\]$MSYSTEM\[\e[0m\] \[\e[33m\]\w\[\e[0m\]\n\$
export PS1="\[\e[33m\]\w\[\e[1;36m\](\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))\[\033[m\] "
#윈도 git path 제거
#https://tldp.org/LDP/abs/html/string-manipulation.html
#export PATH=${PATH%/mnt/c/Users/tsp/AppData/Local/Atlassian/SourceTree/git_local/mingw32/bin:*}

source /home/tsp/vcpkg/scripts/vcpkg_completion.bash
export VCPKG_ROOT=$HOME/vcpkg
export BROWSER=firefox

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tsp/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tsp/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tsp/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tsp/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

#aihub
export AIHUB_ID=taeksoonp@gmail.com
#export AIHUB_PW=''
