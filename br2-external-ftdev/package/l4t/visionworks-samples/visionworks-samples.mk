# URLs extracted from JetPack v2.2.1
VISIONWORKS_SAMPLES_VERSION = 1.4.3
VISIONWORKS_SAMPLES_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/003/linux-x64
VISIONWORKS_SAMPLES_SOURCE = libvisionworks-repo_$(VISIONWORKS_SAMPLES_VERSION)_armhf_l4t-r21.deb
VISIONWORKS_SAMPLES_LICENSE = EULA
VISIONWORKS_SAMPLES_LICENSE_FILES = usr/share/doc/libvisionworks-samples/copyright
VISIONWORKS_SAMPLES_REDISTRIBUTE = NO

VISIONWORKS_SAMPLES_DEPENDENCIES = host-pkgconf cuda visionworks \
	libnvxio opencv4tegra eigen libglfw

VISIONWORKS_SAMPLES_INNER_SRC = libvisionworks-samples_$(VISIONWORKS_SAMPLES_VERSION)_armhf.deb
VISIONWORKS_SAMPLES_INNER_SRC_PREFIX = ./var/visionworks-repo/

# Note that the NVXIO_CFLAGS below are not suitable for building
# libnvxio itself.
VISIONWORKS_SAMPLES_BUILD_FLAGS = ARMv7=1 \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) \
	PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig \
	NVXIO_CFLAGS='-DUSE_GSTREAMER=1 -DUSE_GSTREAMER_OMX=1' \
	NVXIO_LIBS=$(STAGING_DIR)/usr/lib/libnvxio.a \

visionworks-samples-src-root = usr/share/visionworks/sources
visionworks-samples-target-root = usr/share/visionworks/samples

define VISIONWORKS_SAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) $(VISIONWORKS_SAMPLES_BUILD_FLAGS) \
		-C $(@D)/$(visionworks-samples-src-root) all
endef

define VISIONWORKS_SAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/$(visionworks-samples-target-root)/bin
	$(INSTALL) $(@D)/$(visionworks-samples-src-root)/bin/armv7l/linux/release/* \
		$(TARGET_DIR)/$(visionworks-samples-target-root)/bin
	cp -r -t $(TARGET_DIR)/$(visionworks-samples-target-root) \
		$(@D)/$(visionworks-samples-src-root)/data
	$(INSTALL) -d $(TARGET_DIR)/$(visionworks-samples-target-root)/doc
	$(INSTALL) -m 644 $(@D)/$(visionworks-samples-src-root)/*/*/*.md \
		$(TARGET_DIR)/$(visionworks-samples-target-root)/doc
endef

$(eval $(prebuilt-nested-package))
