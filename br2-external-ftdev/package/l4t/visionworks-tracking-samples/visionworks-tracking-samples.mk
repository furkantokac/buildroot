# URLs extracted from JetPack v2.2.1
VISIONWORKS_TRACKING_SAMPLES_VERSION = 0.82.3
VISIONWORKS_TRACKING_SAMPLES_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/003/linux-x64
VISIONWORKS_TRACKING_SAMPLES_SOURCE = libvisionworks-tracking-repo_$(VISIONWORKS_TRACKING_SAMPLES_VERSION)_armhf_l4t-r21.deb
VISIONWORKS_TRACKING_SAMPLES_LICENSE = EULA
VISIONWORKS_TRACKING_SAMPLES_LICENSE_FILES = usr/share/doc/libvisionworks-tracking-dev/copyright
VISIONWORKS_TRACKING_SAMPLES_INSTALL_STAGING = YES
VISIONWORKS_TRACKING_SAMPLES_REDISTRIBUTE = NO

VISIONWORKS_TRACKING_SAMPLES_DEPENDENCIES = host-pkgconf visionworks \
	visionworks-tracking libnvxio

VISIONWORKS_TRACKING_SAMPLES_INNER_SRC = libvisionworks-tracking-dev_$(VISIONWORKS_TRACKING_SAMPLES_VERSION)_armhf.deb
VISIONWORKS_TRACKING_SAMPLES_INNER_SRC_PREFIX = ./var/visionworks-tracking-repo/

VISIONWORKS_TRACKING_SAMPLES_BUILD_FLAGS = ARMv7=1 \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) \
	PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig \
	NVXIO_CFLAGS='-DUSE_GSTREAMER=1 -DUSE_GSTREAMER_OMX=1' \
	NVXIO_LIBS=$(STAGING_DIR)/usr/lib/libnvxio.a \
	EIGEN_CFLAGS=-I$(STAGING_DIR)/usr/include/eigen3 \
	GLFW3_CFLAGS= GLFW3_LIBS=-lglfw

visionworks-tracking-samples-src-root = usr/share/visionworks-tracking/sources
visionworks-tracking-samples-target-root = usr/share/visionworks/samples

define VISIONWORKS_TRACKING_SAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) $(VISIONWORKS_TRACKING_SAMPLES_BUILD_FLAGS) \
		-C $(@D)/$(visionworks-tracking-samples-src-root)/samples/object_tracker all
endef

define VISIONWORKS_TRACKING_SAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/$(visionworks-tracking-samples-target-root)/bin/tracking
	$(INSTALL) $(@D)/$(visionworks-tracking-samples-src-root)/bin/armv7l/linux/release/* \
		$(TARGET_DIR)/$(visionworks-tracking-samples-target-root)/bin/tracking
	$(INSTALL) -d $(TARGET_DIR)/$(visionworks-tracking-samples-target-root)/data
	cp -r $(@D)/$(visionworks-tracking-samples-src-root)/data/tracking \
		$(TARGET_DIR)/$(visionworks-tracking-samples-target-root)/data
	$(INSTALL) -d $(TARGET_DIR)/$(visionworks-tracking-samples-target-root)/doc
	$(INSTALL) -m 644 -t $(TARGET_DIR)/$(visionworks-tracking-samples-target-root)/doc \
		$(@D)/$(visionworks-tracking-samples-src-root)/samples/object_tracker/*.md
endef

$(eval $(prebuilt-nested-package))
