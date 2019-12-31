#
# Util
#
alias showwhbs='env|egrep "(WHBS|CROSS|BUILD_BASE_DIR)"|sort'
#alias ccargs='find $Path -name \*.[hc] -or -name \*.cpp |xargs'
function findcc()
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
	find $Path -type f -name \*.[hc] -or -name \*.cpp -or -name \*.inc |grep -v project_linux |xargs egrep -n $Target $3 $4 $5
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
	Consrc1=$Console_top/qt/examples/qws/console
	Consrc2=$Console_top/src/console4k
	Myprj_top=~/prj/$Myprj
	
	#aliases들은 lazy 변수임
	alias tt='cd $Console_top'
	alias c='cd $Consrc1'
	alias x='cd $Consrc1/project_linux/xml'
	alias ts='cd $Consrc1/project_linux/ts'
	alias u='cd $Consrc1/ui/v5'
	alias bb='cd $Consrc1/project_linux'
	alias ccc='cd $Consrc1/project_linux/${WHBS_CONSOLE_TARGETID}'
	alias bbb='cd $Console_top/console/project_window/'
	alias cccc='cd $Console_top/console/project_window/${WHBS_CONSOLE_TARGETID}'
	alias v="cd $Consrc1/etc/vm"
	
	alias ttt='cd $Myprj_bld'
	alias t='cd $Myprj_top'
	alias r='cd $Myprj_bld/root'
	alias k='cd $Myprj_bld/linux;sbldenv'
	alias s='cd $Myprj_bld/root/src;sbldenv'
	alias n='cd $Myprj_bld/root/src/edvrcore_v7'
	alias b='cd $Myprj_bld/root/build'
	alias dist='cd $Myprj_bld/root/dist'
	
	alias trunk='cd ~/prj/trunk/console/qt/examples/qws/console'
	alias 11729='cd ~/prj/b11729_R10.0/console/qt/examples/qws/console'
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
		there=$Consrc1/../spotosd
		;;
	qws)
		there=$Consrc1/..
		;;
	tests)
		there=$Consrc1/../tests
		;;
	esac
	
	cd $there	
}

# Model ID 찾기
function model_id() {
# '-' 넣기
#  ~f-~ dvr/nvr, ~p-~ nvr, uhn6400-xxx
# 대문자로 변환
	sed '
		s_\([0-9]\)\([fp]\)\([a-z]\)_\1\2-\3_g
		s_00h_00-h_g
		
		s_\(.*\)_\U\1_
		' <<< $1
}

#
# prj 변환 alias
#
alias wprj='config_prj wrns'
alias hprj='config_prj trunk'
#br RB-10.2N, 9707 atsumi, 8822, 7550, 6205
alias rb1='config_prj RB-10.2N'
alias b11729='config_prj  b11729_R10.2'
alias b10241='config_prj  b10241_R9.6'	#191129 ELMO사용
alias b6205='config_prj r6205_R8.8'
alias b5311='config_prj r5311_HDC422FD'
alias b4223='config_prj r4223_R7.8.10'

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
		echo 한다.
		set_`cat $HOME/etc/hi.model`_specific_env
		set_console_socid
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ 설정 끝"
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
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ build 환경 설정 끝"
		popd
	fi
}

#
# pts prj 환경: main
#
source ~/prj/bin/myprj
source ~/etc/global_definitions

#
#  edvr_hddvr_hisilicon_env에서 model 환경 변수 설정 함수 추출하기
#
[ -f "~/etc/model_specific_env.$Myprj" ] || sed -n '
	/exit 1/ d
	/function set_common_post_env/,/model environment variable/ p
	/SOC ID & Console bin path/,/version environment variable/ p
	s/export WHBS_QT_VERSION=/function set_console_socid {/p
'	~/prj/$Myprj/edvr_hddvr_hisilicon_env.sh > ~/etc/model_specific_env.$Myprj
source ~/etc/model_specific_env.$Myprj
sprjenv	#set my project env.
set_common_post_env

#
# console include의 vfs2_definitions_for_diskconf_struct.h 심볼릭 링크 검사
#
[ -L "$Myprj_top/include/vfs2_definitions_for_diskconf_struct.h" ] || ln -s\
	vfs2_definitions_for_normal_diskconf_struct.h $Myprj_top/include/vfs2_definitions_for_diskconf_struct.h
