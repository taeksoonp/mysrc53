# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#util
function bb_model_str () {
	Top=~/builds.hi
	
	#model version 추출
	Tmp=`sed 's_'$Top'/__' <<< $PWD`
	Model_id=`awk -F. '{print toupper($1)}' <<< $Tmp`
	Model_str=`awk -F. '{print $1}' <<< $Tmp`
	
	#version
	Version=`cat $Top/version.bld`
	
	#모델 검사
	KnownModels="HD1600F-PDR HDC400F-PD HDC801F-PD HDC400F HDC1601M HDC801H\
		HD1600F-R HD400F-PDR HD1600M-PDR HD800F-PDR HD800F-R GRH-K1104B\
		GRH-K2108B GRH-K4116B HD1600F HDC801F\
		HS1600FD HSC1601FD HSC801FD"
	
	sed 's_-__g' <<< $KnownModels | awk -v Model="$Model_id" '{
		for(i=1; i<=NF; i++) if ($i==Model) exit 0
		exit 3}'
	
	if [ $? = 0 ]
	then echo $Model_str
	else echo $Model_str NG...
	exit 3
	fi
}

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
alias o='cd $HOME/nfs/kny/OnvifServer_20130210'
alias oo='cd $HOME/nfs/kny/OnvifServer_20130210/OnvifServer'
alias ooo='cd $HOME/nfs/kny/OnvifServer_20130210/OnvifServerDll'
alias t='cd `cat $Myprj`'
alias stringfiles="cd `cat $Myprj`/root/pcsw/string_files"
alias dist='cd `cat $Myprj`/root/dist'

alias t2='cd ~/nfs/trunk2/root/src'
}

function hiprj()
{
alias r='cd `cat $Myprj`/root'
alias k='cd `cat $Myprj`/linux'
alias s='cd `cat $Myprj`/root/src'
alias c='cd `cat $Myprj`/console/qt/examples/qws/console'
alias n='cd `cat $Myprj`/root/src/edvrcore_v6'
alias nn='cd `cat $Myprj`/root/src/p2p'
alias v='cd `cat $Myprj`/root/src/vfs'
alias b='cd `cat $Myprj`/root/build'
alias bb='cd `cat $Myprj`/console'
alias o='cd $HOME/nfs/kny/OnvifServer_20130210'
alias oo='cd $HOME/nfs/kny/OnvifServer_20130210/OnvifServer'
alias ooo='cd $HOME/nfs/kny/OnvifServer_20130210/OnvifServerDll'
alias t='cd `cat $Myprj`'
alias stringfiles="cd `cat $Myprj`/root/pcsw/string_files"
alias dist='cd `cat $Myprj`/root/dist'
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
alias o='cd `cat $Myprj`/root/src/service/OnvifServer/OnvifServer'
alias oo='cd `cat $Myprj`/root/src/service/OnvifServer/OnvifServer/onvif'
alias ooo='cd $HOME/nfs/kny/OnvifServer_20130210/OnvifServer'
alias oooo='cd $HOME/nfs/kny/OnvifServer_20130210/OnvifServerDll'
alias t='cd `cat $Myprj`'

alias nnn='cd /home/ts.p/nfs/hidvr/root/src/edvrcore_v6'
alias nnnn='cd ~/nfs/trunk2/root/src/edvrcore/'
alias ccc='n&&cd build/w*'
}

function ccc() {
	if [ "/home/ts.p/builds.hi" = "`cat $Myprj`" ]; then
		cd `cat $Myprj`/`bb_model_str`.$VerSubfix/console/qt/examples/qws/console/project_linux/webgate_`bb_model_str`
	else
		cd `cat $Myprj`/console/qt/examples/qws/console/project_linux/${WHBS_BUILD_OEM_STR}_${WHBS_BUILD_MODEL_STR}
	fi
}
function cccc() {
	if [ "/home/ts.p/builds.hi" = "`cat $Myprj`" ]; then
		cd `cat $Myprj`/`bb_model_str`.$VerSubfix/console/console/project_window/webgate_`bb_model_str`
	else
		cd `cat $Myprj`/console/console/project_window/${WHBS_BUILD_OEM_STR}_${WHBS_BUILD_MODEL_STR}
	fi
}

alias l='ls -lF --color=tty';
#alias nfs="cd ~/nfs"
#alias prj="cd ~/prj"
alias bank="cd ~/nfs/bank"
alias mk.img=mk_image
alias grep='egrep -n'
#? alias eclid='emacsclient /gg5:$PWD'
alias svnn='/usr/bin/svn'
function findcc () {
if [ $# -eq 0 ]; then
echo "Usage: findcc [path] <pattern>"
return
elif [ $# -gt 1 ]; then
Path=$1
Target=$2
else
Path=.
Target=$1
fi 
find $Path -name \*.[hc] -or -name \*.cpp |xargs egrep -n --exclude v4* --exclude idregister* --exclude .uic* --exclude .moc* $Target
}

function sprj () {
    case "$1" in
	tt)
	    echo "$HOME/nfs/trunk2" > $Myprj
	    ;;
	hd)
	    echo "$HOME/nfs/hddvr" > $Myprj
	    ;;
	hh) #801h
	    echo "$HOME/nfs/hidvr" > $Myprj
	    echo 6 > $HOME/nfs/myetc/hi.conf
	    echo 6.1.555 >> $HOME/nfs/myetc/hi.conf
	    ;;
	    
#1) HD1600F-PDR    8) HD400F-PDR   15) HSC801F-D    22) GRH-K2108B
#2) HDC400F-PD     9) HD1600M-PDR  16) HSC1601F-D   23) GRH-K4116B
#3) HDC801F-PD    10) HD800F-PDR   17) HTC801F      24) GRX-K4416A
#4) HDC400F       11) HD800F-R     18) HTC1601F     25) HDR16L
#5) HDC1601M      12) HD1600F      19) HSC801H-D    26) HDR08M
#6) HDC801H       13) HDC801F      20) HSC1601H-D   27) HDR16M
#7) HD1600F-R     14) HS1600F-D    21) GRH-K1104B
	hi) #19) HSC801H-D
	    echo "$HOME/nfs/hidvr" > $Myprj
	    echo 19 > $HOME/nfs/myetc/hi.conf
	    echo 6.0.99pts >> $HOME/nfs/myetc/hi.conf
	    ;;
	hii) #20) HSC1601H-D
	    echo "$HOME/nfs/hidvr" > $Myprj
	    echo 20 > $HOME/nfs/myetc/hi.conf
	    echo 6.0.99pts >> $HOME/nfs/myetc/hi.conf
	    ;;
	hiii) #17) HTC801F
	    echo "$HOME/nfs/hidvr" > $Myprj
	    echo 17 > $HOME/nfs/myetc/hi.conf
	    echo 6.0.99pts >> $HOME/nfs/myetc/hi.conf
	    ;;
	hiiii) #18) HTC1601F
	    echo "$HOME/nfs/hidvr" > $Myprj
	    echo 18 > $HOME/nfs/myetc/hi.conf
	    echo 6.0.99pts >> $HOME/nfs/myetc/hi.conf
	    ;;

	hi1) #HD1600F-PDR
	    echo "$HOME/nfs/hidvr" > $Myprj
	    echo 1 > $HOME/nfs/myetc/hi.conf
	    echo 6.0.99pts >> $HOME/nfs/myetc/hi.conf
	    ;;
	
	hi16) #16) HSC1601F-D 
	    echo "$HOME/nfs/hidvr" > $Myprj
	    echo 16 > $HOME/nfs/myetc/hi.conf
	    echo 6.9.4 >> $HOME/nfs/myetc/hi.conf
	    ;;
	    	    
	n) #14) HS1601F-D - nvr
	    echo "$HOME/nfs/hidvr" > $Myprj
	    echo 14 > $HOME/nfs/myetc/hi.conf
	    echo 6.7.99nvr >> $HOME/nfs/myetc/hi.conf
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
	    echo tt:trunk2, hd:hddvr, hh:hd801h, hi,hii,hiii,hiii, n:nvr, oo, hh:60x, dd:srd480rtsp, mm:mpeg, sss:04s, gpl, wrns, w:webeye?
	    echo currently, `cat $Myprj`, $Model
	    return 0
    esac

	sprjenv
}

#pts prj
Myprj=~/etc/myprj
function sprjenv()
{
	#pts hidvr env
	myprjname=`cat $Myprj` 
	if [ "$myprjname" = "$HOME/nfs/hidvr" -o "$myprjname" = "$HOME/nfs/hh60x" ]; then
		pushd .
		cd $myprjname
		. $myprjname/edvr_hddvr_hisilicon_env.sh < $HOME/nfs/myetc/hi.conf
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ 설정 끝"
		popd
    hiprj
    
	elif [ "$myprjname" = "$HOME/nfs/webeye" ]; then
		pushd .
		cd $myprjname
		. $myprjname/env_hi_ipcam.sh <<< 5.7.99pts
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ webeye 설정 끝"
		popd
		
		webiprj
		
	else
		echo My project is `cat $Myprj`
		export CROSS_COMPILE_PREFIX=
		export CROSS_COMPILE=
		export CROSS_HOST=
		
    newprj
	fi
}

function showhienv()
{
echo $WHBS_BUILD_MODEL_ID, $WHBS_BUILD_MODEL_STR
echo $WHBS_BUILD_OEM_ID, $WHBS_BUILD_OEM_STR
echo $WHBS_BUILD_MODEL_MAGIC, $WHBS_BUILD_VERSION
echo $WHBS_HI3531_BIN_PATH
echo $WHBS_HI3532_BIN_PATH
echo $WHBS_CONSOLE_BIN_PATH
echo $WHBS_FPGA_FILE
echo $CROSS_COMPILE
}

#etc
export PATH=~/bin/cross:~/bin:~/opt/bin:~/local/bin:$PATH
export EDITOR=eemacs
#export EDITOR=vim
export PS1='\w\$ '
#emacs client
export EMACS_SERVER_FILE=~/etc/server/server
export LD_LIBRARY_PATH=$HOME/local/lib:/usr/local/lib:/usr/local/gcc491/lib:/usr/lib
export LD_RUN_PATH=/usr/local/gcc491/lib
export CDPATH=.:~:~/nfs:~/prj
alias euckr='export LANG=ko_KR.euckr'

export LANG=ko_KR.UTF-8
export TERM=xterm-256color

sprjenv	#set my project env.
