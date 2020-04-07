LIBTBB_VERSION = 4.2
LIBTBB_SOURCE = tbb42_20140601oss_src.tgz
LIBTBB_SITE = https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source
LIBTBB_LICENSE = GPLv2
LIBTBB_LICENSE_FILES = COPYING
LIBTBB_INSTALL_STAGING = YES

# Intel has their own ideas how to name an architecture.
# Translate ARCH to their representation.
libtbb-intelarch-i686    := ia32
libtbb-intelarch-x86_64  := intel64
libtbb-intelarch-arm     := armv7
libtbb-intelarch-powerpc := ppc
libtbb-intelarch-sparc   := sparc
$(eval libtbb-intelarch := $$(libtbb-intelarch-$(ARCH)))

ifeq ($(libtbb-intelarch),)
	$(error libtbb: Unsupported architecture $(ARCH))
endif

define LIBTBB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) \
		-C $(@D)/src \
		arch=$(libtbb-intelarch) compiler=gcc \
		runtime=cc$(GCC_VERSION)_libc$(GLIBC_VERSION)_kernel$(LINUX_VERSION_PROBED) \
		tbbmalloc_release tbb_release
endef

define libtnbb-install-to
	$(INSTALL) -m 644 $(@D)/build/linux_*_release/lib*.so.* $(1)/usr/lib
endef

LIBTBB_INSTALL_TARGET_CMDS = $(call libtnbb-install-to,$(TARGET_DIR))
define LIBTBB_INSTALL_STAGING_CMDS
	$(call libtnbb-install-to,$(STAGING_DIR))
	ln -sf libtbb.so.2 $(STAGING_DIR)/usr/lib/libtbb.so
	ln -sf libtbbmalloc.so.2 $(STAGING_DIR)/usr/lib/libtbbmalloc.so
	ln -sf libtbbmalloc_proxy.so.2 $(STAGING_DIR)/usr/lib/libtbbmalloc_proxy.so
endef

$(eval $(generic-package))
