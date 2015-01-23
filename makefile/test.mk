OBJS = host.mk

all: $(OBJS) foo

host.%: filetype = $(@:host.%=%)
host.%: test.%
	@echo $(filetype)
	@echo $(dir $@)
	@echo $(suffix $@)
	@echo $(basename $@)
	@echo $(wildcard *.mk)
	@echo $(origin OBJS)

define func
tmp = $(OBJPATH)/$(strip $1)
objs += $$(tmp)
$$(tmp) : $2
	gcc $$^ -o $$@
endef

$(info $(call func, foo, 1.c))
$(info ------------------------)

$(eval $(call func, foo, 1.c))


