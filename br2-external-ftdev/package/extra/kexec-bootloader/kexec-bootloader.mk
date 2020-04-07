KEXEC_BOOTLOADER_VERSION = 0.1
KEXEC_BOOTLOADER_SOURCE = kexec-bootloader-$(KEXEC_BOOTLOADER_VERSION).tar.gz
KEXEC_BOOTLOADER_SITE = http://ftp.avionic-design.de/pub/kexec-bootloader
KEXEC_BOOTLOADER_LICENSE = GPLv2
KEXEC_BOOTLOADER_DEPENDENCIES = sdl sdl_ttf fontconfig host-pkgconf

define KEXEC_BOOTLOADER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 $(KEXEC_BOOTLOADER_PKGDIR)/S01kexec \
		$(TARGET_DIR)/etc/init.d/S01kexec
	$(INSTALL) -D -m 755 $(KEXEC_BOOTLOADER_PKGDIR)/S21kexec-bootloader \
		$(TARGET_DIR)/etc/init.d/S21kexec-bootloader
endef

$(eval $(autotools-package))
