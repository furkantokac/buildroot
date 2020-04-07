NVIDIA_ISLANDGL_VERSION = 0.1
NVIDIA_ISLANDGL_SITE = http://ftp.avionic-design.de/pub/nvidia-islandgl
NVIDIA_ISLANDGL_SOURCE = IslandGL_v01.tgz
NVIDIA_ISLANDGL_LICENSE = EULA
NVIDIA_ISLANDGL_LICENSE_FILES = Tegra_Software_License_Agreement.txt
NVIDIA_ISLANDGL_REDISTRIBUTE = NO
NVIDIA_ISLANDGL_DEPENDENCIES = nvidia-drivers
NVIDIA_ISLANDGL_EXTRA_DOWNLOADS = $(NVIDIA_ISLANDGL_LICENSE_FILES)
NVIDIA_ISLANDGL_STRIP_COMPONENTS = 1

nvidia-islandgl-lib-dir := /usr/lib/nvidia-islandGL
nvidia-islandgl-data-dir := /usr/share/nvidia-islandGL

define NVIDIA_ISLANDGL_EXTRACT_CMDS
	$(TAR) -C $(NVIDIA_ISLANDGL_DIR) --strip-components=$(NVIDIA_ISLANDGL_STRIP_COMPONENTS) \
		$(TAR_OPTIONS) $(DL_DIR)/$(NVIDIA_ISLANDGL_SOURCE)
	cp $(DL_DIR)/$(NVIDIA_ISLANDGL_EXTRA_DOWNLOADS) $(NVIDIA_ISLANDGL_DIR)
endef

define NVIDIA_ISLANDGL_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)$(nvidia-islandgl-data-dir)
	tar -C $(NVIDIA_ISLANDGL_DIR) -cO shaders textures | \
		tar -C $(TARGET_DIR)$(nvidia-islandgl-data-dir) -xf -
	$(INSTALL) -d $(TARGET_DIR)$(nvidia-islandgl-lib-dir)
	$(INSTALL) $(NVIDIA_ISLANDGL_DIR)/islandGL $(TARGET_DIR)$(nvidia-islandgl-lib-dir)
	$(INSTALL) $(NVIDIA_ISLANDGL_DIR)/nvidia-islandGL $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
