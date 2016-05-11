# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
function newprj()
{
alias r='cd `cat $Myprj`/root'
alias k='cd `cat $Myprj`/linux'
alias s='cd `cat $Myprj`/root/src'
alias c='cd `cat $Myprj`/root/src/console_2.x'
alias n='cd `cat $Myprj`/root/src/edvrcore'
alias v='cd `cat $Myprj`/root/src/vfs2/filesys'
alias b='cd `cat $Myprj`/root/build'
alias t='cd `cat $Myprj`'
alias stringfiles="cd `cat $Myprj`/root/pcsw/string_files"
alias dist='cd `cat $Myprj`/root/dist'
}

function hiprj()
{
alias r='cd `cat $Myprj`/root'
alias k='cd `cat $Myprj`/linux'
alias gsss='cd `cat $Myprj`/root/src'
alias ghi3532src='cd `cat $Myprj`/hi3532_src'
alias s='cd `cat $Myprj`/console/qt/examples/qws/spotosd'
alias c='cd `cat $Myprj`/console/qt/examples/qws/console'
alias v='cd `cat $Myprj`/console/qt/examples/qws/console/etc/vm'
alias ccc="cd `cat $Myprj`/console/qt/examples/qws/console/project_linux/${WHBS_CONSOLE_TARGETID}"
alias cccc="cd `cat $Myprj`/console/console/project_window/${WHBS_CONSOLE_TARGETID}"
alias bb="cd `cat $Myprj`/console/qt/examples/qws/console/project_linux"
alias bbb="cd `cat $Myprj`/console/console/project_window/"
alias n='cd `cat $Myprj`/root/src/edvrcore_v6'
alias nn='cd `cat $Myprj`/root/src/edvrcore'
alias b='cd `cat $Myprj`/root/build'
alias t='cd `cat $Myprj`'
alias tt='cd `cat $Myprj`'/console
alias ts="cd `cat $Myprj`/console/qt/examples/qws/console/project_linux/ts"
alias dist='cd `cat $Myprj`/root/dist'
alias uv="cd `cat $Myprj`/console/qt/examples/qws/console/ui/v5"
alias uh="cd `cat $Myprj`/console/qt/examples/qws/console/ui/hs"
alias xx="cd `cat $Myprj`/console/qt/examples/qws/console/project_linux/xml"
alias xxx="cd `cat $Myprj`/console/console/project_window/xml"

#br
Brprj=~/nfs/br
alias brr='cd $Brprj/root'
alias brk='cd $Brprj/linux'
alias brs='cd $Brprj/root/src'
alias brc='cd $Brprj/console/qt/examples/qws/console'
alias brccc="cd $Brprj/console/qt/examples/qws/console/project_linux/${WHBS_BUILD_OEM_STR}_${WHBS_BUILD_MODEL_STR}"
alias brcccc="cd $Brprj/console/console/project_window/${WHBS_BUILD_OEM_STR}_${WHBS_BUILD_MODEL_STR}"
alias brbb="cd $Brprj/console/qt/examples/qws/console/project_linux"
alias brbbb="cd $Brprj/console/console/project_window/"
alias brn='cd $Brprj/root/src/edvrcore_v6'
alias brnn='cd $Brprj/root/src/edvrcore'
alias bruv="cd $Brprj/console/qt/examples/qws/console/ui/v5"
alias bruh="cd $Brprj/console/qt/examples/qws/console/ui/hs"

#onvif
alias o='cd ~/nfs/webeye/root/src/service/onvif/OnvifServer'
alias oo='cd ~/nfs/webeye/root/src/service/onvif/OnvifServer/onvif'
alias ooo='cd ~/nfs/webeye/root/src/service/onvif'
}

function webiprj()
{
alias r='cd `cat $Myprj`/root'
alias k='cd `cat $Myprj`/linux'
alias s='cd `cat $Myprj`/root/src/service'
alias n='cd `cat $Myprj`/root/src/service/es_svr'
alias nn='cd `cat $Myprj`/root/src/service/es_svr/protocols/rtsp'
alias c='cd `cat $Myprj`/root/src/systool/cfg'
alias b='cd `cat $Myprj`/root/build/build'
alias o='cd `cat $Myprj`/root/src/service/onvif/OnvifServer'
alias oo='cd `cat $Myprj`/root/src/service/onvif/OnvifServer/onvif'
alias ooo='cd `cat $Myprj`/root/src/service/onvif'

alias oooo='cd `cat $Myprj`/root/src/service/ovf27/OnvifServer'
alias ooooo='cd $HOME/nfs/kny/OnvifServer_20130210/OnvifServer'
alias oooooo='cd $HOME/nfs/kny/OnvifServer_20130210/OnvifServerDll'
alias t='cd `cat $Myprj`'

alias nnn='cd /home/ts.p/nfs/hidvr/root/src/edvrcore_v6'
alias nnnn='cd ~/nfs/hidvr/root/src/edvrcore_v6/'
alias ccc='n&&cd build/w*'
alias cccc='cd ~/nfs/hidvr/console/qt/examples/qws/console'
}

alias l='ls -lF --color=tty';
alias bank="cd ~/nfs/bank"
alias mk.img=mk_image
alias grep='egrep -n'
#? alias eclid='emacsclient /gg5:$PWD'
alias svnn='/usr/bin/svn'
alias findxml='find -name \*.xml'

function findcc () {
  if [ $# -eq 0 ]; then
  echo "Usage: findcc [path] <pattern>"
  echo "Tip: If you want space in pattern, you can do it like this 'findcc abc\sxyz'"
  return
  elif [ $# -gt 1 ]; then
  Path=$1
  Target=$2
  else
  Path=.
  Target=$1
  fi
  
  find $Path -name \*.[hc] -or -name \*.cpp |xargs egrep -n --exclude .uic* --exclude .moc* $Target
}

#
#	Model ID 찾기
#
function model_id() {
	sed '
s/h/h-/g
s/f/f-/g
s/x/x-/g

s/h-$/h/
s/f-$/f/
s/m-$/m/
s/x-$/x/
s/^h-/h/
s/^f-/f/
s/^m-/m/
s/^x-/x/

s/\(.*\)/\U\1/

' <<< $1
}

function sprj () {
    case "$1" in
	tt)
	    echo "$HOME/nfs/trunk2" > $Myprj
	    ;;
	hd)
	    echo "$HOME/nfs/hddvr" > $Myprj
	    ;;

	hi)
	    echo hi는 hprj로 해라.
	    return;
	    ;;
	
	oo) #onvif
	    echo "$HOME/nfs/ovdvr" > $Myprj
	    ;;
	sss)
	    echo "$HOME/nfs/nvs04s" > $Myprj
	    ;;
	wrns)
	    echo "$HOME/nfs/wrns/wrs2" > $Myprj
	    ;;
	    
	w)
	    echo "$HOME/nfs/webeye" > $Myprj
	    ;;

	*)
	    echo "tt:trunk2, hd:hddvr, n:nvr, oo, sss:04s, wrns, w:webeye?"
	    echo currently, `cat $Myprj`, $Model
	    return 0
    esac

	sprjenv
}

function setprj () {
if [ "$2" ]; then
	echo "$HOME/nfs/$1" > $Myprj
	model_id $2 > $HOME/etc/hi.conf
	echo $Myver > $HOME/etc/hi.ver
else
	echo "what model? 어떤거?"
	echo currently, `cat $Myprj`, $Model
	return
fi

sprjenv
}

function hprj () {
if [ "$1" ]; then
setprj hidvr $1
else
setprj
fi
}

function brprj () {
if [ "$1" ]; then
setprj br $1
else
setprj
fi
}

function hdcprj () {
if [ "$1" ]; then
setprj r1752_R6.X $1
else
setprj
fi
}

#pts prj
Myprj=~/etc/myprj
Myver=7.11.99pts
WebeyeVer=1.1.99pts
function sprjenv()
{
	#pts hidvr env
	myprjname=`cat $Myprj`
	if [ "$myprjname" = "$HOME/nfs/hidvr" -o\
	 "$myprjname" = "$HOME/nfs/hinew" -o\
	 "$myprjname" = "$HOME/nfs/br" -o\
	 "$myprjname" = "$HOME/nfs/r1752_R6.X" ]; then
		pushd .
		cd $myprjname
		pwd
		echo edvr_hddvr_hisilicon_env.sh `cat $HOME/etc/hi.conf $HOME/etc/hi.ver` 한다.
		. $myprjname/edvr_hddvr_hisilicon_env.sh `cat $HOME/etc/hi.conf $HOME/etc/hi.ver`
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ 설정 끝"
		popd
    hiprj
    
	elif [ "$myprjname" = "$HOME/nfs/webeye" ]; then
		pushd .
		cd $myprjname
		. $myprjname/env_hi_ipcam.sh <<The_end
$WebeyeVer
1
The_end
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ webeye 설정 끝"
		popd
		
		webiprj
		
	else
		echo My project is `cat $Myprj`
		unset CROSS_COMPILE_PREFIX
		unset CROSS_COMPILE
		unset CROSS_HOST
		
    newprj
	fi
}

function showhienv()
{
echo $CROSS_COMPILE
echo $WHBS_BUILD_MODEL_ID, $WHBS_BUILD_MODEL_STR
echo $WHBS_BUILD_OEM_ID, $WHBS_BUILD_OEM_STR
echo $WHBS_BUILD_MODEL_MAGIC, $WHBS_BUILD_VERSION
echo $WHBS_HI3531_BIN_PATH
echo $WHBS_HI3532_BIN_PATH
echo $WHBS_CONSOLE_BIN_PATH
echo $WHBS_FPGA_FILE
}

#etc
export PATH=~/bin/cross:~/bin:~/opt/bin:~/local/bin:$PATH
export SVN_EDITOR=gedit
export PS1='\w\$ '
#emacs client
export EMACS_SERVER_FILE=~/etc/server/server
export LD_LIBRARY_PATH=$HOME/local/lib:/usr/local/lib:/usr/local/gcc491/lib:/usr/lib
export LD_RUN_PATH=/usr/local/gcc491/lib
#.이 맨 앞에 있어야 한다.
export CDPATH=.:~:~/nfs:~/nfs/hidvr:~/prjwork:~/mysrc53/trunk
export LANG=ko_KR.UTF-8
export TERM=xterm-256color
export Ga_hih="[가-힣]"
alias euckr='export LANG=ko_KR.euckr'
alias mysrc='cd ~/mysrc53/trunk'

sprjenv	#set my project env.
