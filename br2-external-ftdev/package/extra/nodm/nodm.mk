################################################################################
#
# nodm
#
################################################################################

# nodm v0.7 is not tagged on github
NODM_VERSION = 5cc4b689bd0f864a50f40a2b27f5c752b1d3ca76
NODM_SITE = $(call github,spanezz,nodm,$(NODM_VERSION))
NODM_LICENSE = GPLv2
NODM_LICENSE_FILES = COPYING
NODM_DEPENDENCIES = linux-pam
NODM_INSTALL_STAGING = NO
NODM_AUTORECONF = YES

define NODM_INSTALL_EXTRA
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL)/package/extra/nodm/S90nodm \
		$(TARGET_DIR)/etc/init.d/S90nodm
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL)/package/extra/nodm/pam.nodm \
		$(TARGET_DIR)/etc/pam.d/nodm
endef

NODM_POST_INSTALL_TARGET_HOOKS += NODM_INSTALL_EXTRA

$(eval $(autotools-package))
