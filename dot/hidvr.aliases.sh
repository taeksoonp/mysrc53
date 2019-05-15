#
# Util
#
alias showwhbs='env|egrep "(WHBS|CROSS)"|sort'
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
  find $Path -type f -name \*.[hc] -or -name \*.cpp |grep -v project_linux |xargs egrep -n $Target $3 $4 $5
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

# Model ID 찾기
function model_id() {
	sed '
s/\([0-9]\)f\([a-z]\)/\1f-\2/g
s/h\([0-9]\)$/-h\1/g

s/\(.*\)/\U\1/
' <<< $1
}

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
	echo model은 $2 임

elif [ "$1" = wrns ]; then
	echo "Myprj=../wrns" > ~/prj/bin/myprj
	echo PC > $HOME/etc/hi.conf

else
	echo "what model? 어떤거?"
	echo currently, $Myprj, `cat $HOME/etc/hi.conf`
	return
fi

source ~/prj/bin/myprj
sprjenv
sbldenv

#
# soc id 검사
#
if [ "$WHBS_BUILD_SOCID" = "${Myprj_bld: -1}" ]
then echo 좋아.
else 
	echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
	echo "$Myprj_top 하고 socid-$WHBS_BUILD_SOCID 하고 안 맞는다?"
fi
}

#wrns
alias wprj='config_prj wrns'

#trunk
alias hprj='config_prj trunk'

#br 11104, 10241, 9707 atsumi, 8822, 7550, 6205
alias b11104='config_prj b11104_R10.0a'
alias b10241='config_prj b10241_R9.6a'
alias batsumic='config_prj b8822_r9707_atsumic'
alias b8822='config_prj b8822_R9.4a'
alias b7550='config_prj r7550_R9.2a'
alias bnice='config_prj r6205_R8.8_NICEa'
alias b6205='config_prj r6205_R8.8a'
alias b4223='config_prj r4223_R7.8.10'

#wns
alias wprj='config_prj wrns/wrs2 wrns'

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
alias sss='cd $Consrc1/../spotosd'
alias qws='cd $Consrc1/..'
alias i='cd $Consrc1/../oemskin2'

alias bld='cd $Myprj_bld'
alias t='cd $Myprj_top'
alias r='cd $Myprj_bld/root'
alias k='cd $Myprj_bld/linux'
alias s='cd $Myprj_bld/root/src'
alias n='cd $Myprj_bld/root/src/edvrcore_v6'
alias o='cd $Myprj_bld/root/src/onvif_client'
alias b='cd $Myprj_bld/root/build'
alias dist='cd $Myprj_bld/root/dist'

alias trunk='cd ~/prj/trunk/console/qt/examples/qws/console'
alias 11104='cd ~/prj/b11104/console/qt/examples/qws/console'
}

#
# pts prj 환경: main
#
source ~/prj/bin/myprj
function sprjenv()
{
	hiprj_aliases
	Hiconf=`cat $HOME/etc/hi.conf`
	if [ "$Hiconf" = PC ];then
		echo pc linux임
	else
		pushd .
		echo edvr_hddvr_hisilicon_env.sh `cat $HOME/etc/hi.conf $HOME/etc/hi.ver` 한다.
		cd $Myprj_top &&. ./edvr_hddvr_hisilicon_env.sh `cat $HOME/etc/hi.conf $HOME/etc/hi.ver`\
			|| echo $Myprj_top/edvr_hddvr_hisilicon_env.sh 없냐?
		echo "^^^^^^^^^^^^^^^^^^^^^^^^^^ 설정 끝"
		popd
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

sprjenv	#set my project env.