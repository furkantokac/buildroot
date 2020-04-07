################################################################################
#
# irqbalance fork that works on ARM
#
################################################################################

IRQBALANCE_IMX_VERSION = 7f31046b5de183f268f560b42ed9ed25e62c018b
IRQBALANCE_IMX_SITE = $(call github,dv1,irqbalanced,$(IRQBALANCE_IMX_VERSION))
IRQBALANCE_IMX_LICENSE = GPLv2
IRQBALANCE_IMX_LICENSE_FILES = COPYING
IRQBALANCE_IMX_DEPENDENCIES = host-pkgconf
# Autoreconf needed because package is distributed without a configure script
IRQBALANCE_IMX_AUTORECONF = YES

# This would be done by the package's autogen.sh script
define IRQBALANCE_IMX_PRECONFIGURE
	mkdir -p $(@D)/m4
endef

IRQBALANCE_IMX_PRE_CONFIGURE_HOOKS += IRQBALANCE_IMX_PRECONFIGURE

define IRQBALANCE_IMX_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/irqbalance/S13irqbalance \
		$(TARGET_DIR)/etc/init.d/S13irqbalance
endef

define IRQBALANCE_IMX_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/irqbalance/irqbalance.service \
		$(TARGET_DIR)/usr/lib/systemd/system/irqbalance.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/irqbalance.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/irqbalance.service
endef

$(eval $(autotools-package))
