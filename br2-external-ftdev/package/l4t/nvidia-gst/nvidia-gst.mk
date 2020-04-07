################################################################################
#
# l4t/nvidia-gst
#
################################################################################

NVIDIA_GST_VERSION_MAJOR = 21
NVIDIA_GST_VERSION_MINOR = 5.0
NVIDIA_GST_VERSION = $(NVIDIA_GST_VERSION_MAJOR).$(NVIDIA_GST_VERSION_MINOR)
NVIDIA_GST_SOURCE = Tegra124_Linux_R$(NVIDIA_GST_VERSION)_armhf.tbz2
NVIDIA_GST_SITE = http://developer.download.nvidia.com/embedded/L4T/r$(NVIDIA_GST_VERSION_MAJOR)_Release_v$(NVIDIA_GST_VERSION_MINOR)
NVIDIA_GST_LICENSE = custom
NVIDIA_GST_LICENSE_FILES = Linux_for_Tegra/nv_tegra/LICENSE
NVIDIA_GST_INSTALL_STAGING = YES
NVIDIA_GST_INSTALL_TARGET = YES
NVIDIA_GST_STRIP_COMPONENTS = 0

NVIDIA_GST_INNER_SRC         = Linux_for_Tegra/nv_tegra/nv_sample_apps/nvgstapps.tbz2
NVIDIA_GST_OUTER_SRC_EXTRACT_EXTRA = $(NVIDIA_GST_LICENSE_FILES)

define NVIDIA_GST_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/lib/gstreamer-0.10/
	$(INSTALL) -d $(STAGING_DIR)/usr/lib/gstreamer-1.0/
	$(INSTALL) -D -m 0755 $(@D)/usr/lib/arm-linux-gnueabihf/*.so.0 $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/usr/lib/arm-linux-gnueabihf/gstreamer-0.10/*.so $(STAGING_DIR)/usr/lib/gstreamer-0.10/
	$(INSTALL) -D -m 0755 $(@D)/usr/lib/arm-linux-gnueabihf/gstreamer-1.0/*.so $(STAGING_DIR)/usr/lib/gstreamer-1.0/
	$(INSTALL) -d $(STAGING_DIR)/etc/xdg
	$(INSTALL) -D -m 0644 $(@D)/etc/xdg/gstomx.conf $(STAGING_DIR)/etc/xdg/
endef

define NVIDIA_GST_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/gstreamer-0.10/
	$(INSTALL) -d $(TARGET_DIR)/usr/lib/gstreamer-1.0/
	$(INSTALL) -D -m 0755 $(@D)/usr/lib/arm-linux-gnueabihf/*.so.0 $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/usr/lib/arm-linux-gnueabihf/gstreamer-0.10/*.so $(TARGET_DIR)/usr/lib/gstreamer-0.10/
	$(INSTALL) -D -m 0755 $(@D)/usr/lib/arm-linux-gnueabihf/gstreamer-1.0/*.so $(TARGET_DIR)/usr/lib/gstreamer-1.0/
	$(INSTALL) -d $(TARGET_DIR)/etc/xdg
	$(INSTALL) -D -m 0644 $(@D)/etc/xdg/gstomx.conf $(TARGET_DIR)/etc/xdg/

	$(INSTALL) -d $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 0755 $(@D)/usr/bin/nvgst{capture,player}-{0.10,1.0} $(TARGET_DIR)/usr/bin; \
	ln -sf nvgstcapture-1.0 $(TARGET_DIR)/usr/bin/nvgstcapture
	ln -sf nvgstplayer-1.0 $(TARGET_DIR)/usr/bin/nvgstplayer
endef

$(eval $(prebuilt-nested-package))
