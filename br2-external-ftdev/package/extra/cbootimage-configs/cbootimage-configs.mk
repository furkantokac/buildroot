################################################################################
#
# cbootimage-configs
#
################################################################################

CBOOTIMAGE_CONFIGS_VERSION = 9d45319
CBOOTIMAGE_CONFIGS_SITE = $(call github,avionic-design,cbootimage-configs,$(CBOOTIMAGE_CONFIGS_VERSION))
CBOOTIMAGE_CONFIGS_DEPENDENCIES = host-cbootimage uboot
CBOOTIMAGE_CONFIGS_INSTALL_TARGET = NO
CBOOTIMAGE_CONFIGS_INSTALL_IMAGES = YES

CONFIGS_BUILD = $(call qstrip,$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BUILD))
BCT_NAME = $(call qstrip,$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BCT))
IMG_NAME = $(call qstrip,$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_IMG))
EXTRA_BOOTCMD = $(call qstrip,$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_FLASHER_EXTRA_BOOTCMD))
GPT_FILE = $(call qstrip,$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_FLASHER_GPT_FILE))
DFU_MAP = $(call qstrip,$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_FLASHER_DFU_MAP))
KEY_FILE = $(call qstrip,$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_IMG_KEY))

ifeq ($(BR2_PACKAGE_CBOOTIMAGE_CONFIGS),y)
ifeq ($(CONFIGS_BUILD),)
$(error No cbootimage-configuration specififed to build. Check your BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BUILD setting)
endif
ifeq ($(BCT_NAME),)
$(error No bct filename specified. Check your BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BCT setting)
endif
ifeq ($(IMG_NAME),)
$(error No img filename specified. Check your BR2_PACKAGE_CBOOTIMAGE_CONFIGS_IMG setting)
endif

ifneq ($(KEY_FILE),)
KEY_OPTS = skb=$(KEY_FILE)
IMG_FILENAME = $(IMG_NAME).simg
else
IMG_FILENAME = $(IMG_NAME).img
endif
endif

define CBOOTIMAGE_CONFIGS_BUILD_CMDS
	cp $(UBOOT_BUILDDIR)/u-boot-dtb-tegra.bin $(@D)/$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BUILD)/u-boot.bin
	(cd $(@D)/$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BUILD) && $(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) $(KEY_OPTS))
endef

# Generate a self-contained u-boot image, flashing u-boot to mmc
define CBOOTIMAGE_CONFIGS_BUILD_FLASHER_CMDS
	# Generate flasher
	# GPT file: $(GPT_FILE)
	$(HOST_MAKE_ENV) $(CBOOTIMAGE_CONFIGS_PKGDIR)/gen-flasher.sh \
		$(if $(GPT_FILE),-g "$(GPT_FILE)") \
		$(if $(DFU_MAP),-d "$(DFU_MAP)") \
		$(if $(EXTRA_BOOTCMD),-e "$(EXTRA_BOOTCMD)") \
		$(UBOOT_BUILDDIR) $(@D)/$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BUILD)/$(IMG_FILENAME) $(@D)/u-boot-flasher.bin
endef

define CBOOTIMAGE_CONFIGS_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BUILD)/$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BCT) $(BINARIES_DIR)
	cp -f $(@D)/$(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_BUILD)/$(IMG_FILENAME) $(BINARIES_DIR)
endef

define CBOOTIMAGE_CONFIGS_INSTALL_FLASHER_CMDS
	cp -f $(@D)/u-boot-flasher.bin $(BINARIES_DIR)
endef

ifeq ($(BR2_PACKAGE_CBOOTIMAGE_CONFIGS_GENERATE_FLASHER),y)
# Add the actual assembly hook
CBOOTIMAGE_CONFIGS_POST_BUILD_HOOKS += CBOOTIMAGE_CONFIGS_BUILD_FLASHER_CMDS
CBOOTIMAGE_CONFIGS_POST_INSTALL_IMAGES_HOOKS += CBOOTIMAGE_CONFIGS_INSTALL_FLASHER_CMDS
endif

$(eval $(generic-package))
