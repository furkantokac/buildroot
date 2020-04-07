# URLs extracted from JetPack v2.2.1
CUDNN_SAMPLES_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/001/linux-x64
CUDNN_SAMPLES_CUDA_VERSION = 6.5
CUDNN_SAMPLES_VERSION = v2
CUDNN_SAMPLES_SOURCE = cudnn_$(CUDNN_SAMPLES_VERSION)_target.tgz
CUDNN_SAMPLES_LICENSE = EULA
CUDNN_SAMPLES_LICENSE_FILES = License.txt
CUDNN_SAMPLES_REDISTRIBUTE = NO

CUDNN_SAMPLES_DEPENDENCIES = cuda cudnn libfreeimage

CUDNN_SAMPLES_INNER_SRC = cudnn-sample-$(CUDNN_SAMPLES_VERSION).tgz

CUDNN_SAMPLES_BUILD_FLAGS = \
	CUDA_PATH=$(STAGING_DIR)/usr/local/cuda-$(CUDNN_SAMPLES_CUDA_VERSION) \
	LFLAGS="-lcudnn -lfreeimage $(shell $(PKG_CONFIG_HOST_BINARY) --libs \
		$(addsuffix -$(CUDNN_SAMPLES_CUDA_VERSION),cudart nppi nppc cublas))"

cudnn-samples-target-dir = /usr/local/cuda-$(CUDNN_SAMPLES_CUDA_VERSION)/samples

define CUDNN_SAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) $(CUDNN_SAMPLES_BUILD_FLAGS) -C $(@D)
endef

define CUDNN_SAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/$(cudnn-samples-target-dir)/bin
	$(INSTALL) $(@D)/mnistCUDNN $(TARGET_DIR)/$(cudnn-samples-target-dir)/bin
	$(INSTALL) -d $(TARGET_DIR)/$(cudnn-samples-target-dir)/7_CUDALibraries/mnistCUDNN/data
	$(INSTALL) -t $(TARGET_DIR)/$(cudnn-samples-target-dir)/7_CUDALibraries/mnistCUDNN/data \
		-m 644 $(@D)/data/*
endef

$(eval $(prebuilt-nested-package))
