#
# Util
#
alias showwhbs='env|egrep "(WHBS|CROSS|BUILD_BASE_DIR)"|sort'
#alias ccargs='find $Path -name \*.[hc] -or -name \*.cpp |xargs'
function findcc0()
{
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
 
#ng-_-;  find $Path -type f -not -path "*/project_linux/*" -name \*.[hc] -or -name \*.cpp |xargs egrep -n $Target $3 $4 $5
#공란이 있으면 실패	find $Path -type f -name \*.[hc] -or -name \*.cpp -or -name \*.inc |grep -v project_linux |xargs egrep -n $Target $3 $4 $5
	find $Path -type f \( -name \*.[hc] -o -name \*.[hc]pp -o -name \*.inc -o -name \*.rc -o -name \*.cs \) -exec egrep $Grep_args $Target {} \;
}

function findcci()
{
	Grep_args=-nHi findcc0 $*|grep -v project_
}

function findcc()
{
	Grep_args=-nH findcc0 $*|grep -v project_
}

function findcc2()
{
	Grep_args=-nH -A1 findcc0 $*|grep -v project_
}

function findui()
{
	if [ $# -eq 0 ]; then
		echo "Usage: findui [path] <pattern>"
		return
	elif [ $# -gt 1 ]; then
		Path=$1
		Target=$2
	else
		Path=.
		Target=$1
	fi

	find $Path -type f -name \*.qss -or -name \*.ini -or -name hd_factory.cpp -or -name \*.ui |xargs egrep -n $Target $3 $4 $5
}

function findjs()
{
	if [ $# -eq 0 ]; then
		echo "Usage: findjs [path] <pattern>"
		return
	elif [ $# -gt 1 ]; then
		Path=$1
		Target=$2
	else
		Path=.
		Target=$1
	fi
  
#ng-_-;  find $Path -type f -not -path "*/project_linux/*" -name \*.[hc] -or -name \*.cpp |xargs egrep -n $Target $3 $4 $5
	find $Path -type f -name \*.js -or -name \*.html -or -name \*.ts |grep -v .min.js|xargs egrep -n $Target $3 $4 $5
}

#
# pts prj 환경: 매번. eclipse 공용.
#
function hiprj_aliases()
{
	Console_top=~/prj/$Myprj/console
	Console_src=$Console_top/src
	Rb1=RB-10.6.100
	Rb2=RB-10.6.200
	Rb3=RB-10.6.300
	Rbs1=RB-SONE-0.3.0
	Rb8=RB-10.8.0
	
	if [ "$Myprj" = wrns ]; then
		Consrc1=~/prj/$Myprj/wrs2
	else
		Consrc1=$Console_top/src/console
	fi
	Consrc2=$Console_top/src/console4k
	Myprj_top=~/prj/$Myprj
	
	#aliases들은 lazy 변수임
	alias tt='cd $Console_top'
	alias s='cd $Console_top/src'
	alias c='cd $Consrc1'
	alias v="cd $Console_top/lib/qt4"

	alias ts='cd $Consrc1/project_linux/ts'
	alias u='cd $Consrc1/ui/v5'
	alias uu='cd $Consrc1/ui/s1'
	alias bb='cd $Consrc1/project_linux'
	alias ccc='cd $Consrc1/project_linux/${WHBS_CONSOLE_TARGETID}'
	alias bbb='cd $Consrc1/project_window/'
	alias cccc='cd $Consrc1/project_window/${WHBS_CONSOLE_TARGETID}'
	
	alias ttt='cd $Myprj_bld'
	alias t='cd $Myprj_top'
	alias tinclude='cd $Myprj_top/include'
	alias r='cd $Myprj_bld/root'
	alias k='cd $Myprj_bld/linux;sbldenv'
	alias sss='cd $Myprj_bld/root/src;sbldenv'
	alias sss1='cd $Myprj_bld/root/src/s1service;sbldenv'
	alias sssp='cd $Myprj_bld/root/src/p2p;sbldenv'
	alias n='cd $Myprj_bld/root/src/edvrcore_v7'
	alias b='cd $Myprj_bld/root/build'
	alias dist='cd $Myprj_bld/root/dist'
}

function go()
{
	case $1 in
	base)
		there=$Myprj_bld/root/base2
		;;
	linux-common)
		there=$Myprj_bld/linux-common
		;;
	busybox)
		there=$Myprj_bld/root/src/busybox*
		;;
	udhcp)
		there=$Myprj_bld/root/src/busybox*/networking/udhcp
		;;
	onvif)
		there=$Myprj_bld/root/src/onvif_client
		;;
	webapp)
		there=$Myprj_bld/root/src/webapp
		;;
	spotosd)
		there=$Console_src/spotosd
		;;

	tests)
		there=$Console_src/tests
		;;
	tests64)
		there=~/prj/tests64
		;;
	rb1)	
		there=~/prj/$Rb1/console/qt/examples/qws/console
		;;
	esac
	
	cd $there	
}

# Model ID 찾기
function model_id() {
# '-' 넣기
# dvr: 숫자f-알파벳, nvr: 숫자p-알파벳, uhn6400-xxx
# 200427 dvr, nvr 1개(uhn1600-h2-v2) 임시? 
	sed '
#ex) shn808ph2v3
		s/\([0-9]\)\([fp]\)\([a-z]\)/\1\2-\3/
		s/\(-h[0-9]\)\([a-z]\)/\1-\2/
#v2들, 2번째는 노예들 ex) uhn1600h2v2
		s/h\([0-9]\)v\([0-9]\)/h\1-v\2/
		s/urv2/ur-v2/
#00-Hxxx
		s/\([0-9]\)h\([0-9]\)/\1-h\2/	
#대문자로 변환
		s/\(.*\)/\U\1/
		' <<< $1
}

#
# prj 변환 alias
#
alias wprj='config_prj wrns'
alias hprj='config_prj trunk'
alias nprj='config_prj novatek15071'
#br RB-10.2N, 9707 atsumi, 8822, 7550, 6205
alias rb1='config_prj $Rb1'
alias rb2='config_prj $Rb2'
alias rb3='config_prj $Rb3'
alias rbs1='config_prj $Rbs1'
alias rb8='config_prj $Rb8'

#
# prj. 환경 설정
#
# 190515 $1 Mycon 퇴출
# $1 Myprj, $2 model_id
#
function config_prj() {
	if [ "$2" ]; then
		echo "Myprj=$1" > ~/prj/bin/myprj
		model_id $2 > $HOME/etc/hi.conf
		echo $2 >  $HOME/etc/hi.model
		echo model은 $2 임
	
	elif [ "$1" = wrns ]; then
		echo "Myprj=wrns" > ~/prj/bin/myprj
		echo PC > $HOME/etc/hi.conf
	
	else
		echo "what model? 어떤거?"
		echo currently, $Myprj, `cat $HOME/etc/hi.conf`
		return
	fi
	source ~/prj/bin/myprj
	source ~/etc/global_definitions
	sprjenv
	sbldenv

#
# soc id(알파벳 한 자) 검사
#
	if [ "$WHBS_BUILD_SOCID" = "${Myprj_bld: -1}" ]; then
		echo 좋아.
	else 
		echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
		echo "$Myprj_top 하고 socid-$WHBS_BUILD_SOCID 하고 안 맞는다?"
	fi
}

function sprjenv()
{
	hiprj_aliases
	if [ "$Hiconf" = PC ];then
		echo pc linux임
	else
##		echo 한다.
		set_`cat $HOME/etc/hi.model`_specific_env
		set_console_socid
##		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ 설정 끝"
	fi
	
	#lazy var
	Myprj_bld=~/prj/sdb1/$Myprj$WHBS_BUILD_SOCID
}

function sbldenv()
{
	hiprj_aliases
	Hiconf=`cat $HOME/etc/hi.conf`
	if [ "$Hiconf" = PC ];then
		echo pc linux임
	else
		pushd .
		echo \'$Myprj_bld\'에서 edvr_hddvr_hisilicon_env.sh `cat $HOME/etc/hi.conf $HOME/etc/hi.ver` 한다.
		cd $Myprj_bld &&. ./edvr_hddvr_hisilicon_env.sh `cat $HOME/etc/hi.conf $HOME/etc/hi.ver`\
			||  echo $Myprj_bld 없냐?
		source ~/etc/global_definitions
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ build 환경 설정 끝. global_definitions만 예외임"
		popd
	fi
}

#
# pts prj 환경: main
#
source ~/prj/bin/myprj
source ~/etc/global_definitions

#
# gcc toolset
#
function host2gts() {
	sed 's/-ca\([0-9]\)-/-ca\1gts-/' <<<$CROSS_HOST
}

#
#  edvr_hddvr_hisilicon_env에서 model 환경 변수 설정 함수 추출하기
#
[ -f "$HOME/etc/model_specific_env.$Myprj" ] || sed -n '
	/exit 1/ d
	/function set_common_post_env/,/model environment variable/ p
	/SOC ID & Console bin path/,/version environment variable/ p
	s/export WHBS_QT_VERSION=/function set_console_socid {/p
'	~/prj/$Myprj/edvr_hddvr_hisilicon_env.sh > ~/etc/model_specific_env.$Myprj

#
# 수동 1개 (set_common_env 생략하고)
# $ARCH: console/lib/qt4/include sybolic link 만들 때 쓴다
#
export ARCH=arm #default arm
source ~/etc/model_specific_env.$Myprj
sprjenv	#set my project env.

#
# 수동 2개
#
export WHBS_OEM_ID_LIST_CFLAGS="-DWEBGATE=0 -DSONE=1"
export WHBS_BUILD_VERSION=`cat $HOME/etc/hi.ver`
t #prj top
function sync_third_party_files {
	echo "copy third_party files to source code"
	if [ ${WHBS_SOC_TYPE} = "NT98323" ]; then
		rsync -arvh root/src/third_party/hikvision_sadp/libs/libsadp_nt98323.so console/lib/etc/arm-nt/libsadp.so
		rsync -arvh root/src/third_party/hikvision_sadp/incEN/Sadp.h console/src/console/lib/sadp/hik_sadp.h
	elif [ ${WHBS_SOC_TYPE} = "NT98336" ]; then
		rsync -arvh root/src/third_party/hikvision_sadp/libs/libsadp_nt98336.so console/lib/etc/arm-nt98336/libsadp.so
		rsync -arvh root/src/third_party/hikvision_sadp/incEN/Sadp.h console/src/console/lib/sadp/hik_sadp.h
	fi
}
sync_third_party_files
#<--수동

set_common_post_env

#
# console include의 vfs2_definitions_for_diskconf_struct.h 심볼릭 링크 검사
#
[ -L "$Myprj_top/include/vfs2_definitions_for_diskconf_struct.h" ] || ln -s\
	vfs2_definitions_for_normal_diskconf_struct.h $Myprj_top/include/vfs2_definitions_for_diskconf_struct.h

