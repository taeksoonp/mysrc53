#!/bin/ash

source /wgi_sys_vars_definition
#deprecated source mycon
source myprj

#vga_output_type
FB_NO=`cat /proc/wgi_sys_vars/console_fb_dev_num`
Vfb_no=`cat /proc/wgi_sys_vars/virtual_fb_dev_num`
Scale=`/usr/edvr/vgaparam -r h`

if [[ "$Vfb_no" -gt "0" && "$Scale" = "3840x2160" ]]; then
FB_NO=$Vfb_no
Wgi_vfb=wgi_vfb
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
elif [ ${soc_type} = ${SOC_TYPE_3521D} ]; then
Soctype=g
elif [ ${soc_type} = ${SOC_TYPE_3531D} ]; then
Soctype=h
elif [ ${soc_type} = ${SOC_TYPE_3516CV300} ]; then
Soctype=i

else
echo error! soctype $Soctype?
exit 1
fi

Version=`awk -F: '{print $2}' /version`
Targetid=hs`cat /proc/wgi_sys_vars/video_ch_cnt`$Soctype

if [[ "$1" && "$1" = "--gdb" ]]; then
	Gdb="./gdbserver.hi --once :10000"

elif [[ "$1" && "$1" = "--callgrind" ]]; then
	export VALGRIND_LIB=/mnt/nfs/local/lib/valgrind
	Gdb="./valgrind --tool=callgrind"
	
elif [[ "$1" && "$1" = "--valgrind" ]]; then
	export VALGRIND_LIB=/mnt/nfs/local/lib/valgrind
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

if [[ "$0" == ./tt ]]; then
	Fullname=ttlinux/$Targetid/$Targetid
elif [[ "$0" == ./jj ]]; then
	Fullname=jjlinux/$Targetid/$Targetid
else
	Fullname=../$Myprj/console/qt/examples/qws/console/project_linux/$Targetid/$Targetid
	echo 이름: "$0"
fi

$Gdb $Fullname $Args --runlevel0 -qws -display linuxfb:/dev/fb${FB_NO}:$Wgi_vfb:size=1920x1080:qws_size=1920x1080:depth=32:mmWidth:480:mmHeight=270 -nokeyboard -font /usr/lib/qt/lib/fonts/arial.ttf
