# URLs extracted from JetPack v2.2.1
VISIONWORKS_SFM_SAMPLES_VERSION = 0.86.2
VISIONWORKS_SFM_SAMPLES_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/003/linux-x64
VISIONWORKS_SFM_SAMPLES_SOURCE = libvisionworks-sfm-repo_$(VISIONWORKS_SFM_SAMPLES_VERSION)_armhf_l4t-r21.deb
VISIONWORKS_SFM_SAMPLES_LICENSE = EULA
VISIONWORKS_SFM_SAMPLES_LICENSE_FILES = usr/share/doc/libvisionworks-sfm-dev/copyright
VISIONWORKS_SFM_SAMPLES_REDISTRIBUTE = NO

VISIONWORKS_SFM_SAMPLES_DEPENDENCIES = host-pkgconf cuda \
	visionworks visionworks-sfm libnvxio eigen

VISIONWORKS_SFM_SAMPLES_INNER_SRC = libvisionworks-sfm-dev_$(VISIONWORKS_SFM_SAMPLES_VERSION)_armhf.deb
VISIONWORKS_SFM_SAMPLES_INNER_SRC_PREFIX = ./var/visionworks-sfm-repo/

# eigen3.pc is only installed with buildroot >= v2016.02, so we can't
# count on it being present
VISIONWORKS_SFM_SAMPLES_BUILD_FLAGS = ARMv7=1 \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) \
	PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig \
	NVXIO_CFLAGS='-DUSE_GSTREAMER=1 -DUSE_GSTREAMER_OMX=1' \
	NVXIO_LIBS=$(STAGING_DIR)/usr/lib/libnvxio.a \
	EIGEN_CFLAGS=-I$(STAGING_DIR)/usr/include/eigen3 \
	GLFW3_CFLAGS= GLFW3_LIBS=-lglfw

visionworks-sfm-samples-src-root = usr/share/visionworks-sfm/sources
visionworks-sfm-samples-target-root = usr/share/visionworks/samples

define VISIONWORKS_SFM_SAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) $(VISIONWORKS_SFM_SAMPLES_BUILD_FLAGS) \
		-C $(@D)/$(visionworks-sfm-samples-src-root)/samples/sfm all
endef

define VISIONWORKS_SFM_SAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/$(visionworks-sfm-samples-target-root)/bin/sfm
	$(INSTALL) $(@D)/$(visionworks-sfm-samples-src-root)/bin/armv7l/linux/release/* \
		$(TARGET_DIR)/$(visionworks-sfm-samples-target-root)/bin/sfm
	$(INSTALL) -d $(TARGET_DIR)/$(visionworks-sfm-samples-target-root)/data
	cp -r $(@D)/$(visionworks-sfm-samples-src-root)/data/sfm \
		$(TARGET_DIR)/$(visionworks-sfm-samples-target-root)/data
	$(INSTALL) -d $(TARGET_DIR)/$(visionworks-sfm-samples-target-root)/doc
	$(INSTALL) -m 644 -t $(TARGET_DIR)/$(visionworks-sfm-samples-target-root)/doc \
		$(@D)/$(visionworks-sfm-samples-src-root)/samples/sfm/*.md
endef

$(eval $(prebuilt-nested-package))
