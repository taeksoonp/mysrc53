#
# sdb1 작업용 makefile
# https://stackoverflow.com/questions/17834582/run-make-in-each-subdirectory
#
Top_targets := all clean tt
Subdirs := $(wildcard trunk?/) $(wildcard [br][0-1]*[a-z]/)

$(Top_targets): $(Subdirs)

$(Subdirs):
	$(MAKE) -C $@ -f ../worker.mk $(MAKECMDGOALS)

tt:
	@echo '$(Mytop)'
	@echo $(MAKECMDGOALS)
	
ttt:
	echo $(MAKECMDGOALS)
    
clean:
	rm console root/dist
	
distclean:
	rm console root/dist -r
	
.PHONY: $(Top_targets) $(Subdirs)

#util
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
