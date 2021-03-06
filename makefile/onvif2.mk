#
#	Onvif server
#

CXX = $(CROSS_COMPILE)g++
CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar
STRIP = $(CROSS_COMPILE)strip

CPPFLAGS = -Ibm -Ionvif -I. -Iwgi -MMD -isystem $(Boost_include)
CXXFLAGS = -O1 -std=c++0x -g3
CFLAGS = -O1 -g3
LDLIBS = -lpthread $(Boost_lib)/libboost_system.a
LINK.o = $(LINK.cc)	#use g++ as linker
Boost_lib = /opt/lib/boost.arm/lib
Boost_include =/opt/lib/boost.arm/include

TARGET = nvt
Bm_objs = word_analyse.o util.o sys_os.o sys_log.o sys_buf.o ppstack.o base64.o sha1.o
Onvif_objs = xml_node.o soap.o onvif_probe.o onvif_pkt.o onvif.o hxml.o http_rx.o \
	soap_parser.o onvif_device.o http_parse.o http_cln.o onvif_timer.o onvif_event.o \
	onvif_api.o onvif_ptz.o onvif_util.o onvif_media.o onvif_image.o onvif_cm.o
Wgi_objs = ipc.o conf.o ptz.o
OBJS = $(Bm_objs:%=bm/%) $(Onvif_objs:%=onvif/%) $(Wgi_objs:%=wgi/%) $(TARGET).o
DEPS = $(OBJS:%.o=%.d)

all: $(TARGET)

$(TARGET): $(OBJS)

install: all
	$(STRIP) $(TARGET) -o ../../../../build/bin/$(TARGET)

clean:
	rm -f $(TARGET) $(OBJS) $(DEPS)

.PHONY: all install clean

#include dependencies if it exists.
# -MMD cpp option generate '~.d' file.
-include $(DEPS)
