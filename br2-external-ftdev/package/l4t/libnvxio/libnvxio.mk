# URLs extracted from JetPack v2.2.1
LIBNVXIO_VERSION = 1.4.3
LIBNVXIO_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/003/linux-x64
LIBNVXIO_SOURCE = libvisionworks-repo_$(LIBNVXIO_VERSION)_armhf_l4t-r21.deb
LIBNVXIO_LICENSE = EULA
LIBNVXIO_LICENSE_FILES = usr/share/doc/libvisionworks-samples/copyright
LIBNVXIO_REDISTRIBUTE = NO
LIBNVXIO_INSTALL_TARGET = NO
LIBNVXIO_INSTALL_STAGING = YES

LIBNVXIO_DEPENDENCIES = host-pkgconf cuda visionworks freetype \
	libgl mesa3d gstreamer1 gst1-plugins-base gst1-plugins-good \
	gst1-plugins-bad opencv4tegra eigen libglfw freefont-ttf

LIBNVXIO_INNER_SRC = libvisionworks-samples_$(LIBNVXIO_VERSION)_armhf.deb
LIBNVXIO_INNER_SRC_PREFIX = ./var/visionworks-repo/

LIBNVXIO_BUILD_FLAGS = ARMv7=1 \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) \
	PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig

libnvxio-src-root = usr/share/visionworks/sources

define LIBNVXIO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(LIBNVXIO_BUILD_FLAGS) \
		$(MAKE) -C $(@D)/$(libnvxio-src-root) nvxio_build
endef

define LIBNVXIO_INSTALL_STAGING_CMDS
	cp -r -t $(STAGING_DIR)/usr/include \
		$(@D)/$(libnvxio-src-root)/nvxio/include/NVXIO
	$(INSTALL) -d $(STAGING_DIR)/usr/lib
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/lib \
		$(@D)/$(libnvxio-src-root)/libs/armv7l/linux/release/libnvxio.a
endef

$(eval $(prebuilt-nested-package))
