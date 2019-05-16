#
# sdb1 작업용 makefile
# https://stackoverflow.com/questions/17834582/run-make-in-each-subdirectory
#

Mytop = $(notdir $(shell pwd)) #make 실행경로임
Branch_name = $(shell python -c "print '$(Mytop)'.strip()[0:-1]")
Svn_cmd = up

all:
	ln -s ../../$(Branch_name)/console
	ln -s ../../dist root/
		
clean:
	-rm console root/dist
	
distclean:
	@if [ -d console ]; then read -p "정말 지울거니?";\
		rm console root/dist -r;fi

$(Svn_cmd):
	svn $@

tt:
	echo $(shell pwd)
	@python -c "print len('$(Mytop)'), '$(Mytop)'.strip()[0:-1]"

.PHONY: all clean distclean tt $(Svn_cmd)

#util
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
