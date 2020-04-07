# URLs extracted from JetPack v2.2.1
CUDNN_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/001/linux-x64
CUDNN_CUDA_VERSION = 6.5
CUDNN_VERSION = v2
CUDNN_SOURCE = cudnn_$(CUDNN_VERSION)_target.tgz
CUDNN_LICENSE = proprietary BSD-3c BSD-2c
CUDNN_LICENSE_FILES = CUDNN_License.pdf
CUDNN_REDISTRIBUTE = NO
CUDNN_INSTALL_STAGING = YES

CUDNN_DEPENDENCIES = cuda

CUDNN_INNER_SRC = cudnn-$(CUDNN_CUDA_VERSION)-linux-ARMv7-$(CUDNN_VERSION).tgz

cudnn-dynamic = $(CUDNN_DIR)/libcudnn.so*
cudnn-static = $(CUDNN_DIR)/libcudnn_static.a

define cudnn-install-cmds
	$(INSTALL) -d $(2)/usr/local/cuda-$(CUDNN_CUDA_VERSION)/lib
	cp -d $(1) $(2)/usr/local/cuda-$(CUDNN_CUDA_VERSION)/lib
endef

define CUDNN_INSTALL_TARGET_CMDS
	$(call cudnn-install-cmds,$(cudnn-dynamic),$(TARGET_DIR))
endef

define CUDNN_INSTALL_STAGING_CMDS
	$(call cudnn-install-cmds,$(cudnn-dynamic) $(cudnn-static),$(STAGING_DIR))
	$(INSTALL) -d $(STAGING_DIR)/usr/local/cuda-$(CUDNN_CUDA_VERSION)/include
	$(INSTALL) -m 644 $(@D)/cudnn.h $(STAGING_DIR)/usr/local/cuda-$(CUDNN_CUDA_VERSION)/include
endef

$(eval $(prebuilt-nested-package))
