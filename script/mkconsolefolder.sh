#!/bin/sh

Branch=`basename $PWD`
if [ "$Branch" != "trunk" ]; then
	Branch=branches/$Branch
fi

if [ ! -d console ]; then
	echo "console 먼저 복사해라"
	return
fi

mkdir -p root/src console/rootsrc/
pushd .
cd console/rootsrc
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/include
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/third_party
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/library

#ref only
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/external_library #for s1service/wgservice
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/s1service
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/wgservice
svn co http://www.webinhome.com/repos/hddvr_hi/$Branch/root/src/onvif_client
svn co http://www.webinhome.com/repos/hddvr_hi/trunk/root/src/socksvr_v2
popd

ln -s console/rootsrc/include/ .
ln -s ../../console/rootsrc/include/ root/src/
ln -s ../../console/rootsrc/library/ root/src/
ln -s ../../console/rootsrc/third_party/ root/src/
sync_third_party_files

if cd include/; then
	ln -s vfs2_definitions_for_normal_diskconf_struct.h vfs2_definitions_for_diskconf_struct.h
	ln -s conf_definitions_for_dvr_and_nvr.h conf_definitions.h
fi