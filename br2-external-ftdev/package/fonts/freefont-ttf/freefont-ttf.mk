FREEFONT_TTF_VERSION = 20120503
FREEFONT_TTF_SITE = http://ftp.gnu.org/gnu/freefont
FREEFONT_TTF_SOURCE = freefont-ttf-$(FREEFONT_TTF_VERSION).zip
FREEFONT_TTF_LICENSE = GPLv3+
FREEFONT_TTF_LICENSE_FILES = COPYING

freefont-ttf-target-dir = /usr/share/fonts/truetype/freefont

FREEFONT_TTF_EXTRACT_CMDS = $(UNZIP) -j $(DL_DIR)/$(FREEFONT_TTF_SOURCE) -d $(@D)

define FREEFONT_TTF_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/$(freefont-ttf-target-dir)
	$(INSTALL) -m 644 $(@D)/*.ttf $(TARGET_DIR)/$(freefont-ttf-target-dir)
endef

$(eval $(generic-package))
