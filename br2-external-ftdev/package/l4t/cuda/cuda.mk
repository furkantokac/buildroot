# URLs extracted from JetPack v2.2.1
CUDA_L4T_VERSION = 21.5
CUDA_VERSION_PATCHLVL = 53
CUDA_VERSION = 6.5
CUDA_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/005/linux-x64
CUDA_SOURCE = cuda-repo-l4t-r$(CUDA_L4T_VERSION)-$(cuda-dash-version)-local_$(CUDA_VERSION)-$(CUDA_VERSION_PATCHLVL)_armhf.deb
CUDA_LICENSE = EULA
CUDA_LICENSE_FILES = usr/local/cuda-$(CUDA_VERSION)/doc/EULA.txt
CUDA_REDISTRIBUTE = NO

CUDA_INSTALL_TARGET = YES
CUDA_INSTALL_STAGING = YES

CUDA_INNER_SRC_PREFIX = ./var/cuda-repo-$(cuda-dash-version)-local/

cuda-debfiles = \
	$(addsuffix -$(cuda-dash-version)_$(CUDA_VERSION)-$(CUDA_VERSION_PATCHLVL)_armhf.deb,$(1))

cuda-inner-src-common = \
	cuda-cublas cuda-cudart cuda-cufft cuda-curand cuda-cusparse \
	cuda-npp cuda-cusolver
CUDA_INNER_SRC_FOR_TARGET = $(call cuda-debfiles, \
	$(cuda-inner-src-common) \
	cuda-command-line-tools \
)
# cuda-cudart-dev is the only package which does not provide a stub
# library, so both cuda-cudart and cuda-cudart-dev are needed in
# staging.
CUDA_INNER_SRC_FOR_STAGING = $(call cuda-debfiles, \
	$(addsuffix -dev,$(cuda-inner-src-common)) \
	cuda-cudart \
	cuda-misc-headers \
	cuda-driver-dev \
)
CUDA_INNER_SRC = $(call cuda-debfiles, \
	cuda-license \
)

cuda-dash-version = $(subst .,-,$(CUDA_VERSION))

define CUDA_INSTALL_TARGET_CMDS
	$(CUDA_INSTALL_FOR_TARGET_CMDS)
	ln -Tsf cuda-$(CUDA_VERSION) '$(TARGET_DIR)/usr/local/cuda'
	$(INSTALL) -d '$(TARGET_DIR)/etc/profile.d'
	$(INSTALL) -m 644 '$(CUDA_PKGDIR)/cuda-ld-library-path.sh' \
		'$(TARGET_DIR)/etc/profile.d'
endef

define CUDA_INSTALL_STAGING_CMDS
	$(CUDA_INSTALL_FOR_STAGING_CMDS)
	ln -Tsf cuda-$(CUDA_VERSION) '$(STAGING_DIR)/usr/local/cuda'
endef

$(eval $(prebuilt-nested-package))
