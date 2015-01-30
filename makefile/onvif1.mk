# Dirs:		sub-directories.
# all:		default and parallel target.
# install clean distclean:	sequencial target.
# %:		More targets. i.e., optional and NO PHONY CHECK.

Dirs = OnvifServer

all: $(Dirs)
$(Dirs):
	make -C $@

install clean distclean:
	$(Dirs:%=make $@ -C % &&) echo $@ done!

%:
	$(Dirs:%=make $@ -C % &&) echo $@ done!

.PHONY: all install clean distclean $(Dirs)