TOP_DIR ?= ./dependencies
PACKAGE_SIGNATURE = ./inc/tag.h

BLUE = \033[00;34m
GREEN = \033[00;32m
NORMAL  = \033[0m
FAILURE=\033[0m\033[05;31m\033[01;31m\033[04;31m

MAJOR_TAG    = $(shell grep "PACKAGE_MAJOR"    $(PACKAGE_SIGNATURE) | head -n1 |sed -e 's/[^0-9]//g')
MINOR_TAG    = $(shell grep "PACKAGE_MINOR"    $(PACKAGE_SIGNATURE) | head -n1 |sed -e 's/[^0-9]//g')
REVISION_TAG = $(shell grep "PACKAGE_REVISION" $(PACKAGE_SIGNATURE) | head -n1 |sed -e 's/[^0-9]//g')
TAG_IDENTIFIER = v$(MAJOR_TAG)r$(MINOR_TAG)p$(REVISION_TAG)
MAKE_OPS ?=--no-print-directory

CONTROL_VERSION ?= $(shell [ -d "$(PWD)/.git" ] && echo git || echo subversion )
ifeq ($(CONTROL_VERSION), subversion)
	url_info        := "$(shell svn info | grep "URL"      | head -n1 |cut -d ' ' -f 2 | sed 's/ //g')"
	subversion_info := "$(shell svn info | grep "Revision" | head -n1 |cut -d ' ' -f 2 | sed 's/ //g')"
	maintainer      := "$(shell svn info | grep "Author"   | head -n1 |cut -d ' ' -f 4 | sed 's/ //g')"
endif 
ifeq ($(CONTROL_VERSION), git)
	url_info        := "$(shell git svn info | grep "URL"      | head -n1 |cut -d ' ' -f 2 | sed 's/ //g')"
	subversion_info := "$(shell git svn info | grep "Revision" | head -n1 |cut -d ' ' -f 2 | sed 's/ //g')"
	maintainer      := "$(shell git svn info | grep "Author"   | head -n1 |cut -d ' ' -f 4 | sed 's/ //g')"
endif

major_info      := "$(shell basename $(call url_info) | cut -f'2' -d'-' | cut -f'1' -d'.' | sed 's/ //g')"
minor_info      := "$(shell basename $(call url_info) | cut -f'2' -d'-' | cut -f'2' -d'.' | sed 's/ //g')"
revision_info   := "$(shell basename $(call url_info) | cut -f'2' -d'-' | cut -f'3' -d'.' | sed 's/ //g')"

tag: 
	@if [ ! -f $(PACKAGE_SIGNATURE) ]; then \
		printf "Rebuilding ${BLUE}$(PACKAGE_SIGNATURE) on $(PACKAGE_ID)${NORMAL}\n"; \
		echo "#ifndef $(PACKAGE_ID)_TAG_inc" > $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_TAG_inc" >> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_COMPILED_BY          \"$(call maintainer)"\" >> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_COMPILER_HOST        \"`hostname`\"">> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_COMPILER_HOST_TYPE   \"`uname -sr`\"" >> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_COMPILED_DATE        \"`export LANG="en";date`\"" >> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_URL_ADDRESS          \"$(call url_info)"\" >> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_PACKAGE_MAJOR        \"$(call major_info)"\">> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_PACKAGE_MINOR        \"$(call minor_info)"\">> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_PACKAGE_REVISION     \"$(call revision_info)"\" >> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_PACKAGE_SUBVERSION   \"$(call subversion_info)"\" >> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_PACKAGE_NAME         \"$(PACKAGE_ID)\"" >> $(PACKAGE_SIGNATURE);\
		echo "#define $(PACKAGE_ID)_PACKAGE_TAG          \"v\" $(PACKAGE_ID)_PACKAGE_MAJOR \"r\" $(PACKAGE_ID)_PACKAGE_MINOR \"p\" $(PACKAGE_ID)_PACKAGE_REVISION \".\" $(PACKAGE_ID)_PACKAGE_SUBVERSION " >> $(PACKAGE_SIGNATURE);\
		echo "#endif" >> $(PACKAGE_SIGNATURE);\
		cat $(PACKAGE_SIGNATURE);\
	fi;
	
clean:
	@for p in $(PLATFORMS); do \
		if [ -f ./build.$$p/Makefile ]; then \
			make $(MAKE_OPS) -C ./build.$$p $@; \
		fi \
	done

distclean:
	@for p in $(PLATFORMS); do \
		if [ -f ./build.$$p/Makefile ]; then \
			make $(MAKE_OPS) -C ./build.$$p $@; \
		fi \
	done
	@for d in $(DEPS); do \
		if [ -f ./build.$$p/Makefile ]; then \
			make $(MAKE_OPS) -C $(TOP_DIR)/$$d clean; \
		fi \
	done

mrproper:
	@for p in $(PLATFORMS); do rm -rf ./build.$$p; done
	@for d in $(DEPS)     ; do rm -rf $(TOP_DIR)/$$d; done

deps:
	@./depend.resolv.py $(DEPEND_SPEC) $(DEPS)
	@for p in $(PLATFORMS); do \
		export DIR=$(TOP_DIR)/build.$$p; \
		if [ ! -d $$DIR ]; then \
				printf "Creating build dir %20s\n" $$DIR; \
				mkdir $$DIR; \
		fi; \
	done
	@for d in $(DEPS); do make $(MAKE_OPS) -C $(TOP_DIR)/$$d; done
