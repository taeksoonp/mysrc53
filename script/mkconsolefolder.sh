#!/bin/sh
Branch=branches/`basename $PWD`

mkdir -p root/src drivers
#svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/console
echo "console은 복사해라"
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/include
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/third_party
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/library
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/drivers/module

ln -s ../../include/ root/src
ln -s ../../library/ root/src
ln -s ../../third_party/ root/src
ln -s ../module/ drivers

ln -s vfs2_definitions_for_normal_diskconf_struct.h include/vfs2_definitions_for_diskconf_struct.h
ln -s conf_definitions_for_dvr_and_nvr.h include/conf_definitions.h
sync_third_party_files
