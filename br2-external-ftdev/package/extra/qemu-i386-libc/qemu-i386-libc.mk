QEMU_I386_LIBC_VERSION = 2.3.6
QEMU_I386_LIBC_SITE = http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/unstable
QEMU_I386_LIBC_SOURCE= qemu-libc-i386_$(QEMU_I386_LIBC_VERSION)-1_arm.ipk

define QEMU_I386_LIBC_EXTRACT_CMDS
	$(RM) -rf $(QEMU_I386_LIBC_DIR)
	mkdir $(QEMU_I386_LIBC_DIR)
	$(TAR) -C $(QEMU_I386_LIBC_DIR) -zxf $(DL_DIR)/$(QEMU_I386_LIBC_SOURCE) ./data.tar.gz
endef

define QEMU_I386_LIBC_INSTALL_TARGET_CMDS
	$(TAR) -C $(TARGET_DIR) -zxf $(QEMU_I386_LIBC_DIR)/data.tar.gz
endef

$(eval $(generic-package))
