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
export PATH=$PATH:/opt/hisi-linux/x86-arm/arm-hisiv200-linux/target/bin:/opt/hisi-linux/x86-arm/arm-hisiv400-linux/target/bin::/opt/hisi-linux/x86-arm/arm-hisiv600-linux/target/bin:/opt/ivot/arm-ca9-linux-gnueabihf-6.5/usr/bin

alias l='ls -lF --color=tty --time-style=long-iso'
alias bank="cd ~/prj/bank"

if [ "$HOSTNAME" = ptslinux ]; then
	export PS1='\w) '
elif [ "$HOSTNAME" = "gigacity7.localdomain" ]; then
#	export PS1='\w] '

#
# git 설정
#
#https://gist.github.com/justintv/168835
#문법: \[\033[NNm\] 또는 \[\e[NNm\]
#노란색 눈부시다	export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\] \[\033[33;1m\]\w\[\033[36m\](\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))\[\033[m\] "
	export PS1="\[\033[32m\]\w\[\033[36m\](\$(git branch 2>/dev/null | grep '^*' | colrm 1 2))\[\033[m\] "

elif [ "$HOSTNAME" = "gigacity6.localdomain" ]; then
	export PS1='\w} '
else
	export PS1='\w? '
fi

#pc용 git이랑 모드 일치시킬라고. 안하면 디폴티 0002
umask 0022

#echo "gcc8 쓴다."
#source scl_source enable devtoolset-4
source scl_source enable devtoolset-9
source scl_source enable rh-git218

#etc
export SVN_EDITOR=emacs
export EMACS_SERVER_FILE=~/etc/server/server
export TERM=xterm-256color
export Ga_hih="[가-힣]"
alias euckr='export LANG=ko_KR.euckr'
alias mysrc='cd ~/prj/mysrc53'
alias prj='cd ~/prj'
alias prjbin='cd ~/prj/bin'
alias prjwork='cd ~/prj/work'
alias prjtmp='cd ~/prj/tmp'
alias prjtt='cd ~/prj/tests64'
alias prjqt='cd ~/prj/qt5trunk'
alias sdb='cd ~/prj/sdb1'

#hidvr
. ~/prj/mysrc53/dot/hidvr.aliases.sh

#rust
#. .cargo/env

#
# text color:
# https://www.howtogeek.com/307701/how-to-customize-and-colorize-your-bash-prompt/
#Black: 30 Blue: 34 Cyan: 36 Green: 32 Purple: 35 Red: 31 White: 37 Yellow: 33
#
#dircolors -b mycolors임
#di=01;30 -> DIR
LS_COLORS='rs=0:di=01;30:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS
