# URLs extracted from JetPack v2.2.1
VISIONWORKS_TRACKING_VERSION = 0.82.3
VISIONWORKS_TRACKING_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/003/linux-x64
VISIONWORKS_TRACKING_SOURCE = libvisionworks-tracking-repo_$(VISIONWORKS_TRACKING_VERSION)_armhf_l4t-r21.deb
VISIONWORKS_TRACKING_LICENSE = EULA
VISIONWORKS_TRACKING_LICENSE_FILES = $(notdir $(VISIONWORKS_TRACKING_FOR_TARGET_DIR))/usr/share/doc/libvisionworks-tracking/copyright
VISIONWORKS_TRACKING_INSTALL_STAGING = YES
VISIONWORKS_TRACKING_REDISTRIBUTE = NO

VISIONWORKS_TRACKING_DEPENDENCIES = cuda visionworks

VISIONWORKS_TRACKING_INNER_SRC_FOR_TARGET = libvisionworks-tracking_$(VISIONWORKS_TRACKING_VERSION)_armhf.deb
VISIONWORKS_TRACKING_INNER_SRC_FOR_STAGING = libvisionworks-tracking_$(VISIONWORKS_TRACKING_VERSION)_armhf.deb \
	libvisionworks-tracking-dev_$(VISIONWORKS_TRACKING_VERSION)_armhf.deb

VISIONWORKS_TRACKING_INNER_SRC_PREFIX = ./var/visionworks-tracking-repo/

define VISIONWORKS_TRACKING_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/NVX/tracking
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/include/NVX/tracking \
		$(VISIONWORKS_TRACKING_FOR_STAGING_DIR)/usr/include/NVX/tracking/*
	$(INSTALL) -d $(STAGING_DIR)/usr/lib
	cp -d -t $(STAGING_DIR)/usr/lib \
		$(VISIONWORKS_TRACKING_FOR_STAGING_DIR)/usr/lib/libvisionworks_tracking.so*
	$(INSTALL) -d $(STAGING_DIR)/usr/lib/pkgconfig
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/lib/pkgconfig \
		$(VISIONWORKS_TRACKING_FOR_STAGING_DIR)/usr/lib/pkgconfig/visionworks-tracking.pc
	$(INSTALL) -d $(STAGING_DIR)/usr/share/visionworks-tracking/cmake
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/share/visionworks-tracking/cmake \
		$(VISIONWORKS_TRACKING_FOR_STAGING_DIR)/usr/share/visionworks-tracking/cmake/*
endef

$(eval $(prebuilt-nested-package))
