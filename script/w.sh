#!/bin/ash

source /wgi_sys_vars_definition
#deprecated source mycon
source myprj

#from exec_console
FB_NO=`cat /proc/wgi_sys_vars/console_fb_dev_num`
Vfb_no=`cat /proc/wgi_sys_vars/virtual_fb_dev_num`
Height=`cat /proc/umap/vo | grep HDMI | grep "1080\|2160" -o`
Soc_type=`cat /proc/wgi_sys_vars/soc_type`
Last_hi=11 #SOC_TYPE_3520DV400

if [[ "$Vfb_no" -gt "0" && "$Height" = "2160" ]]; then
	FB_NO=$Vfb_no
	Wgi_vfb=wgi_vfb
	Hdmi_4k_option=--hdmi4k
fi

#soc_type
if [ ${soc_type} = ${SOC_TYPE_3531} ]; then
Soctype=a
elif [ ${soc_type} = ${SOC_TYPE_3521} ]; then
Soctype=b
elif [ ${soc_type} = ${SOC_TYPE_3520DV300} ]; then
Soctype=c
elif [ ${soc_type} = ${SOC_TYPE_3521A} ]; then
Soctype=c
elif [ ${soc_type} = ${SOC_TYPE_3531A} ]; then
Soctype=d
elif [ ${soc_type} = ${SOC_TYPE_3536} ]; then
Soctype=e
elif [ ${soc_type} = ${SOC_TYPE_3536C} ]; then
Soctype=f
elif [ ${soc_type} = ${SOC_TYPE_3521D} ] || [ ${soc_type} = ${SOC_TYPE_3520DV400} ]; then
Soctype=g
elif [ ${soc_type} = ${SOC_TYPE_3531D} ]; then
Soctype=h
elif [ ${soc_type} = ${SOC_TYPE_3516CV300} ]; then
Soctype=i
elif [ ${soc_type} = 14 ]; then
#노바텍 32bit
Soctype=k

else
echo error! soctype $Soctype?
exit 1
fi

Version=`awk -F: '{print $2}' /version`
Targetid=hs`cat /proc/wgi_sys_vars/video_ch_cnt`$Soctype

if [[ "$1" && "$1" = "--gdb" ]]; then
	Gdb="./gdbserver.hi --once :10000"

elif [[ "$1" && "$1" = "--callgrind" ]]; then
	export VALGRIND_LIB=/mnt/nfs/opt/lib/valgrind
	Gdb="./valgrind --tool=callgrind"
	
elif [[ "$1" && "$1" = "--valgrind" ]]; then
	export VALGRIND_LIB=/mnt/nfs/opt/lib/valgrind
	Gdb="./valgrind"
	
elif [[ "$1" && "$1" = "--target" ]]; then
	Targetid=$2
fi

for var in "$@"; do
	# Ignore known bad arguments
	[ "$var" != '--gdb' ] &&\
	[ "$var" != '--callgrind' ] &&\
	[ "$var" != '--valgrind' ] &&\
	[ "$var" != '--target' ] &&\
	Args="$Args $var"
done

if [ $Soc_type -le $Last_hi ]; then
	Args="$Args ${Hdmi_4k_option} -qws -display linuxfb:/dev/fb${FB_NO}:$Wgi_vfb:size=1920x1080:qws_size=1920x1080:depth=32:mmWidth:480:mmHeight=270 -font /usr/lib/qt/lib/fonts/arial.ttf"
else
	Args="$Args -qws -display linuxfb:/dev/fb${FB_NO}:mmWidth=480:mmHeight=270"
	
#ng. LinuxInput, Microsoft, LinuxTP, Tslib
#ok MouseMan, IntelliMouse
#export QWS_MOUSE_PROTO=MouseMan
fi

if [ ${0:2:2} = "br" ]; then
	Fullname=../$Myprj/console/qt/examples/qws/console/project_linux/$Targetid/$Targetid
else
	Fullname=../$Myprj/console/src/console/project_linux/$Targetid/$Targetid
fi

$Gdb $Fullname $Args --runlevel0
echo fullname: $Fullname
echo args: $Args
echo 이름: "$0", mouse driver: $QWS_MOUSE_PROTO. bye
