
Wvdir = /home/119rnd/swprod/Application_Release/Utilites/Webviewer
Wvcab = WESPWebViewer.cab
Wvzip = latestHDRedist.zip

Folders = WebGate Nobrand
Target ?= webgate
Src_folder ?= WebGate

#
#	webviewer
#
htdocs_$(Target)/$(Wvcab) : $(Target).$(Wvzip)
	rm htdocs_$(Target)/* -rf
	unzip $< -d htdocs_$(Target)
	touch -r $< $@

$(Target).$(Wvzip): $(Wvdir)/$(Src_folder)/$(Wvzip)
	cp $< $@ -f

#
# batch make
#
all: $(Folders)

$(Folders): Target_id = $(call lc,$@)
$(Folders):
	[ -d htdocs_$(Target_id) ] || mkdir htdocs_$(Target_id)
	make Src_folder=$@ Target=$(Target_id)

.PHONY: all $(Folders)

#lower case function
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
