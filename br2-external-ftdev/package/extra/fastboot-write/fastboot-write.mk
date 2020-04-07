FASTBOOT_WRITE_VERSION = 0.1.0
FASTBOOT_WRITE_SOURCE = fastboot-write-$(FASTBOOT_WRITE_VERSION).tar.bz2
FASTBOOT_WRITE_SITE = http://ftp.avionic-design.de/pub/fastboot-write
FASTBOOT_WRITE_LICENSE = GPLv2

$(eval $(autotools-package))
