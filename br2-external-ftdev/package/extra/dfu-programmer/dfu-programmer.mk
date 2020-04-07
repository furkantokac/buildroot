DFU_PROGRAMMER_VERSION = 0.7.1
DFU_PROGRAMMER_SITE = $(call github,dfu-programmer,dfu-programmer,v$(DFU_PROGRAMMER_VERSION))
DFU_PROGRAMMER_LICENSE = GPLv2
DFU_PROGRAMMER_LICENSE_FILES = COPYING
DFU_PROGRAMMER_INSTALL_STAGING = YES

# the package does not come with configure, so autogen needs to be run first
define DFU_PROGRAMMER_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./bootstrap.sh
endef

DFU_PROGRAMMER_PRE_CONFIGURE_HOOKS += DFU_PROGRAMMER_RUN_AUTOGEN
DFU_PROGRAMMER_DEPENDENCIES += host-automake host-autoconf host-libtool

$(eval $(autotools-package))
