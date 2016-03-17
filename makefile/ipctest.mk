CXX = $(CROSS_COMPILE)g++
CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar
STRIP = $(CROSS_COMPILE)strip

CPPFLAGS = -MMD #-isystem $(Boost_include)
CXXFLAGS =	-O -g3 -Wall -fmessage-length=0 -std=c++0x

#none for now: LDLIBS = -lpthread $(Boost_lib)/libboost_system.a
LINK.o = $(LINK.cc)	#use g++ as linker
Boost_lib = /opt/lib/boost.arm/lib
Boost_include =/opt/lib/boost.arm/include

TARGET = ipctest ioctltt 

all:	$(TARGET)

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all install clean
