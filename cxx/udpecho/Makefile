
CPPFLAGS = $(Boost_include) -MMD
CXXFLAGS = -O1 -std=c++11 -g3
CFLAGS = -O1 -g3
#LDLIBS = -lpthread
LINK.o = $(LINK.cc)	#use g++ as linker
#Boost_lib = /opt/lib/boost.arm/lib
#Boost_include = -isystem /opt/lib/boost.arm/include

Targets = udpechoserver udpechoclient
Common = PracticalSocket
DEPS = $(Targets:%=%.d) $(Common).d

all: $(Targets)
udpechoserver: udpechoserver.o $(Common).o
udpechoclient: udpechoclient.o $(Common).o

clean:
	rm -f $(Targets) *.o $(DEPS)

.PHONY: all install clean tt

tt:
	echo $(DEPS)

#include dependencies if it exists.
# -MMD cpp option generate '~.d' file.
# -isystem <DIR> cpp option avoids -MMD option
-include $(DEPS)

#util
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
