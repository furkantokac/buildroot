# URLs extracted from JetPack v2.2.1
CUDA_SAMPLES_L4T_VERSION = 21.5
CUDA_SAMPLES_VERSION = 6.5
CUDA_SAMPLES_VERSION_PATCHLVL = 53
CUDA_SAMPLES_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/005/linux-x64
CUDA_SAMPLES_SOURCE = cuda-repo-l4t-r$(CUDA_SAMPLES_L4T_VERSION)-$(cuda-samples-dash-version)-local_$(CUDA_SAMPLES_VERSION)-$(CUDA_SAMPLES_VERSION_PATCHLVL)_armhf.deb
CUDA_SAMPLES_LICENSE = EULA
CUDA_SAMPLES_LICENSE_FILES = usr/local/cuda-$(CUDA_SAMPLES_VERSION)/doc/EULA.txt
CUDA_SAMPLES_REDISTRIBUTE = NO

CUDA_SAMPLES_DEPENDENCIES += host-cuda-cross-toolchain \
	cuda libgl libglu libglew libfreeglut \
	xlib_libX11 xlib_libXi xlib_libXmu

cuda-samples-dash-version = $(subst .,-,$(CUDA_SAMPLES_VERSION))

cuda-samples-target-dir = /usr/local/cuda-$(CUDA_SAMPLES_VERSION)/samples

cuda-samples-debfiles = \
	$(addsuffix -$(cuda-samples-dash-version)_$(CUDA_SAMPLES_VERSION)-$(CUDA_SAMPLES_VERSION_PATCHLVL)_armhf.deb,$(1))

cuda-samples-inner-src = cuda-samples cuda-license
CUDA_SAMPLES_INNER_SRC = $(call cuda-samples-debfiles,$(cuda-samples-inner-src))

CUDA_SAMPLES_INNER_SRC_PREFIX = ./var/cuda-repo-$(cuda-samples-dash-version)-local/

# The cuda samples build system doesn't use autotools or pkg-config,
# and doesn't find the sysrooted tools and libs.
CUDA_SAMPLES_CFLAGS = \
	$(shell $(PKG_CONFIG_HOST_BINARY) --cflags \
		cuda-$(CUDA_SAMPLES_VERSION))

# Most CUDA .pc files point to the stub library dir, but cudart.pc
# points to the real libraries. Pass both paths to the linker.
CUDA_SAMPLES_LDFLAGS = \
	$(shell $(PKG_CONFIG_HOST_BINARY) --libs-only-L \
		cuda-$(CUDA_SAMPLES_VERSION) \
		cudart-$(CUDA_SAMPLES_VERSION))

# Override and disable findgllib.mk
CUDA_SAMPLES_GLLINK = \
	$(shell $(PKG_CONFIG_HOST_BINARY) --libs-only-L gl)

# K1 has compute capability 3.2. Restrict the gpu code generation to
# that architecture, speeding up compilation.
CUDA_SAMPLES_SMS = 32

# Not all samples work with SMS 32. List the unsupported ones here:
CUDA_SAMPLES_FILTER_OUT_PROJECTS = \
	0_Simple/simpleMPI/Makefile \
	0_Simple/cdpSimplePrint/Makefile \
	0_Simple/cdpSimpleQuicksort/Makefile \
	6_Advanced/cdpAdvancedQuicksort/Makefile \
	6_Advanced/cdpBezierTessellation/Makefile \
	6_Advanced/cdpLUDecomposition/Makefile \
	6_Advanced/cdpQuadtree/Makefile \
	7_CUDALibraries/simpleDevLibCUBLAS/Makefile

CUDA_SAMPLES_BUILD_FLAGS = ARMv7=1 GCC=$(TARGET_CXX) \
	CUDA_PATH=$(HOST_DIR)/usr/local/cuda-$(CUDA_SAMPLES_VERSION) \
	CUDA_SEARCH_PATH=$(STAGING_DIR)/usr/lib/tegra \
	EXTRA_NVCCFLAGS='$(CUDA_SAMPLES_CFLAGS)' \
	EXTRA_LDFLAGS='$(CUDA_SAMPLES_LDFLAGS)' \
	GLLINK='$(CUDA_SAMPLES_GLLINK)' \
	TARGET_FS=$(STAGING_DIR) \
	FILTER-OUT='$(CUDA_SAMPLES_FILTER_OUT_PROJECTS)' \
	SMS='$(CUDA_SAMPLES_SMS)'

cuda-samples-src-root = \
	$(CUDA_SAMPLES_DIR)/usr/local/cuda-$(CUDA_SAMPLES_VERSION)/samples

define CUDA_SAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(cuda-samples-src-root) \
		$(CUDA_SAMPLES_BUILD_FLAGS) all
endef

define CUDA_SAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/$(cuda-samples-target-dir)/bin
	$(INSTALL) $(cuda-samples-src-root)/bin/armv7l/linux/release/$(LIBC)$(ABI)/* \
		$(TARGET_DIR)/$(cuda-samples-target-dir)/bin
	cd $(cuda-samples-src-root) && find . -path '*/data/*' | \
		cpio --quiet -pdum $(TARGET_DIR)/$(cuda-samples-target-dir)
endef

$(eval $(prebuilt-nested-package))
