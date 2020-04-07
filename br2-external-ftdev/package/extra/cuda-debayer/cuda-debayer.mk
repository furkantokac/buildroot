CUDA_DEBAYER_VERSION = v0.2.2
CUDA_DEBAYER_SITE = $(call github,avionic-design,cuda-debayer,$(CUDA_DEBAYER_VERSION))
CUDA_DEBAYER_LICENSE = GPLv2
CUDA_DEBAYER_AUTORECONF = YES

CUDA_DEBAYER_DEPENDENCIES += host-automake host-autoconf host-libtool \
			     host-cuda-cross-toolchain cuda

ifeq ($(BR2_PACKAGE_CUDA_DEBAYER_GL),y)
CUDA_DEBAYER_DEPENDENCIES += libgl libglu libglew libfreeglut
CUDA_DEBAYER_CONF_OPTS += --with-opengl
else
CUDA_DEBAYER_CONF_OPTS += --without-opengl
endif

ifeq ($(BR2_PACKAGE_CUDA_DEBAYER_OPENCV),y)
CUDA_DEBAYER_DEPENDENCIES += opencv4tegra
CUDA_DEBAYER_CONF_OPTS += --with-opencv
else
CUDA_DEBAYER_CONF_OPTS += --without-opencv
endif

CUDA_DEBAYER_CONF_ENV += NVCC=$(HOST_DIR)/usr/local/cuda/bin/nvcc \
			CXXFLAGS='$(TARGET_CXXFLAGS) -O2 -g'

$(eval $(autotools-package))
