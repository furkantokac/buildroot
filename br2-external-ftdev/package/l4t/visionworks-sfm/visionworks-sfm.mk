# URLs extracted from JetPack v2.2.1
VISIONWORKS_SFM_VERSION = 0.86.2
VISIONWORKS_SFM_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/003/linux-x64
VISIONWORKS_SFM_SOURCE = libvisionworks-sfm-repo_$(VISIONWORKS_SFM_VERSION)_armhf_l4t-r21.deb
VISIONWORKS_SFM_LICENSE = EULA
VISIONWORKS_SFM_LICENSE_FILES = $(notdir $(VISIONWORKS_SFM_FOR_TARGET_DIR))/usr/share/doc/libvisionworks-sfm/copyright
VISIONWORKS_SFM_INSTALL_STAGING = YES
VISIONWORKS_SFM_REDISTRIBUTE = NO

VISIONWORKS_SFM_DEPENDENCIES = cuda visionworks

VISIONWORKS_SFM_INNER_SRC_FOR_TARGET = libvisionworks-sfm_$(VISIONWORKS_SFM_VERSION)_armhf.deb
VISIONWORKS_SFM_INNER_SRC_FOR_STAGING = libvisionworks-sfm_$(VISIONWORKS_SFM_VERSION)_armhf.deb \
	libvisionworks-sfm-dev_$(VISIONWORKS_SFM_VERSION)_armhf.deb

VISIONWORKS_SFM_INNER_SRC_PREFIX = ./var/visionworks-sfm-repo/

define VISIONWORKS_SFM_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/NVX/sfm
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/include/NVX/sfm \
		$(VISIONWORKS_SFM_FOR_STAGING_DIR)/usr/include/NVX/sfm/*
	$(INSTALL) -d $(STAGING_DIR)/usr/lib/pkgconfig
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/lib/pkgconfig \
		$(VISIONWORKS_SFM_FOR_STAGING_DIR)/usr/lib/pkgconfig/visionworks-sfm.pc
	cp -d -t $(STAGING_DIR)/usr/lib \
		$(VISIONWORKS_SFM_FOR_STAGING_DIR)/usr/lib/libvisionworks_sfm.so*
	$(INSTALL) -d $(STAGING_DIR)/usr/share/visionworks-sfm/cmake
	$(INSTALL) -m 644 -t $(STAGING_DIR)/usr/share/visionworks-sfm/cmake \
		$(VISIONWORKS_SFM_FOR_STAGING_DIR)/usr/share/visionworks-sfm/cmake/*
endef

$(eval $(prebuilt-nested-package))
