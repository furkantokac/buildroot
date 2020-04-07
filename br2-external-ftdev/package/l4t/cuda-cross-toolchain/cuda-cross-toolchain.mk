# URLs extracted from JetPack v2.2.1
HOST_CUDA_CROSS_TOOLCHAIN_VERSION = 6.5
HOST_CUDA_CROSS_TOOLCHAIN_VERSION_PATCHLVL = 53
HOST_CUDA_CROSS_TOOLCHAIN_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/005/linux-x64
HOST_CUDA_CROSS_TOOLCHAIN_SOURCE = cuda-repo-ubuntu1404-$(cuda-cross-toolchain-dash-version)-local_$(HOST_CUDA_CROSS_TOOLCHAIN_VERSION)-$(HOST_CUDA_CROSS_TOOLCHAIN_VERSION_PATCHLVL)_amd64.deb
HOST_CUDA_CROSS_TOOLCHAIN_LICENSE = EULA
HOST_CUDA_CROSS_TOOLCHAIN_LICENSE_FILES = usr/local/cuda-6.5/doc/EULA.txt
HOST_CUDA_CROSS_TOOLCHAIN_REDISTRIBUTE = NO

HOST_CUDA_CROSS_TOOLCHAIN_DEPENDENCIES = cuda

cuda-cross-toolchain-debfiles = \
	$(addsuffix -$(cuda-cross-toolchain-dash-version)_$(HOST_CUDA_CROSS_TOOLCHAIN_VERSION)-$(HOST_CUDA_CROSS_TOOLCHAIN_VERSION_PATCHLVL)_amd64.deb,$(1))

HOST_CUDA_CROSS_TOOLCHAIN_INNER_SRC = $(call cuda-cross-toolchain-debfiles, \
	cuda-license \
)
HOST_CUDA_CROSS_TOOLCHAIN_INNER_SRC_FOR_HOST = $(call cuda-cross-toolchain-debfiles, \
	cuda-core \
)
cuda-cross-toolchain-dash-version = \
	$(subst .,-,$(HOST_CUDA_CROSS_TOOLCHAIN_VERSION))

HOST_CUDA_CROSS_TOOLCHAIN_INNER_SRC_PREFIX = \
	./var/cuda-repo-$(cuda-cross-toolchain-dash-version)-local/

define HOST_CUDA_CROSS_TOOLCHAIN_INSTALL_CMDS
	$(HOST_CUDA_CROSS_TOOLCHAIN_INSTALL_FOR_HOST_CMDS)
	ln -Tsf cuda-$(HOST_CUDA_CROSS_TOOLCHAIN_VERSION) '$(HOST_DIR)/usr/local/cuda'
endef

$(eval $(host-prebuilt-nested-package))
