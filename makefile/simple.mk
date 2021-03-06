#
# simple common to be included
# usage: 2줄!
#
# Targets: t1 t2 ...
# include ../simple.mk

CPPFLAGS = -MMD $(Dash_isystem_boost_include)
CFLAGS = -O -g $(Sanitizer_flags)
CXXFLAGS = $(CFLAGS) -std=c++11
LDLIBS = -lboost_system-mt -lpthread $(Sanitizer_flags)
LINK.o = $(LINK.cc)	#use g++ as linker
DEPS = $(Targets:%=%.d)
Sanitizer_flags = -fsanitize=address -fno-omit-frame-pointer

all: $(Targets)

clean:
	-rm -f $(Targets) $(DEPS)

.PHONY: all install clean

#include dependencies if it exists.
# -MMD cpp option generate '~.d' file.
-include $(DEPS)

#util
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
