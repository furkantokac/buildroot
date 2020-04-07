# URLs extracted from JetPack v2.2.1
VISIONWORKS_VERSION = 1.4.3
VISIONWORKS_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/003/linux-x64
VISIONWORKS_SOURCE = libvisionworks-repo_$(VISIONWORKS_VERSION)_armhf_l4t-r21.deb
VISIONWORKS_LICENSE = EULA
VISIONWORKS_LICENSE_FILES = $(notdir $(VISIONWORKS_FOR_TARGET_DIR))/usr/share/doc/libvisionworks/copyright
VISIONWORKS_INSTALL_STAGING = YES
VISIONWORKS_REDISTRIBUTE = NO

VISIONWORKS_DEPENDENCIES = cuda

VISIONWORKS_INNER_SRC_FOR_TARGET = libvisionworks_$(VISIONWORKS_VERSION)_armhf.deb
VISIONWORKS_INNER_SRC_FOR_STAGING = libvisionworks_$(VISIONWORKS_VERSION)_armhf.deb \
	libvisionworks-dev_$(VISIONWORKS_VERSION)_all.deb

VISIONWORKS_INNER_SRC_PREFIX = ./var/visionworks-repo/

$(eval $(prebuilt-nested-package))
