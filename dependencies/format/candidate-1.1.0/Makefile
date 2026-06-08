TOP_DIR  = ./dependencies
PLATFORMS ?= i686Android i686linux # i686Android #i686-w64-mingw32 
PACKAGE_ID = libfmt
CMAKEOps = -DBUILD_SHARED_LIBS=OFF -DMINGW=OFF -DFMT_DOC=OFF -DFMT_INSTALL=OFF -DFMT_TEST=OFF
MAKE_OPS ?=--no-print-directory

.phony:all
all: tag
	@for p in $(PLATFORMS); do \
		if [ ! -d ./build.$$p ]; then \
			printf "Creating build dir %20s\n" ./build.$$p; \
			mkdir ./build.$$p; \
			cmake -B ./build.$$p -S./ -DPLATFORM=$$p -DCMAKE_TOOLCHAIN_FILE=../dependencies/builder/$$p.cmake $(CMAKEOps);  \
		fi; \
		make $(MAKE_OPS) -C ./build.$$p; \
	done

install:
ifdef PARENT_DIR
	@for p in $(PLATFORMS); do \
		cp ./build.$$p/${PACKAGE_ID}* $(PARENT_DIR)/build.$$p -dpR; \
	done
endif

include $(TOP_DIR)/builder/MakeRules.mak

