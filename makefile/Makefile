# simple top

Sub_dir = echo1530

all: $(Sub_dir)

$(Sub_dir):
	$(MAKE) -C $(Sub_dir)
	
clean:
	$(MAKE) -C $(Sub_dir) $@

.PHONY: $(Sub_dir) clean
