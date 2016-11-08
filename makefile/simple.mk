#
# tests Makefile
#

CXX = $(CROSS_COMPILE)g++
CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar
STRIP = $(CROSS_COMPILE)strip

CPPFLAGS = -MMD -Iinclude_hi3531
CFLAGS = -O1 -g3
CXXFLAGS = $(CFLAGS) -std=c++0x
LDLIBS = -lpthread
LINK.o = $(LINK.cc)	#use g++ as linker

Targets = hifb_test
DEPS = $(Targets:%=%.d)

all: $(Targets)

clean:
	-rm -f $(Targets) $(DEPS)

.PHONY: all install clean

#include dependencies if it exists.
# -MMD cpp option generate '~.d' file.
-include $(DEPS)
