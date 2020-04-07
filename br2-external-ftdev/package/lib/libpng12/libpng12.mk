################################################################################
#
# libpng12
#
################################################################################

LIBPNG12_VERSION = 1.2.56
LIBPNG12_SERIES = 12
LIBPNG12_SOURCE = libpng-$(LIBPNG12_VERSION).tar.xz
LIBPNG12_SITE = https://netix.dl.sourceforge.net/project/libpng/libpng${LIBPNG12_SERIES}/older-releases/$(LIBPNG12_VERSION)
LIBPNG12_LICENSE = libpng license
LIBPNG12_LICENSE_FILES = LICENSE
LIBPNG12_INSTALL_STAGING = YES
LIBPNG12_DEPENDENCIES = host-pkgconf zlib
LIBPNG12_CONFIG_SCRIPTS = libpng$(LIBPNG12_SERIES)-config libpng-config
LIBPNG12_CONF_OPTS = $(if $(BR2_ARM_CPU_HAS_NEON),--enable-arm-neon=yes,--enable-arm-neon=no)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
