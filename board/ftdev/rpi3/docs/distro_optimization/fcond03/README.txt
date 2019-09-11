----------------------- make kernel-xconfig
### Networking disabled
Disabled;
CONFIG_NET

### Sound disabled
Disabled;
CONFIG_SOUND

### Device tree appended to the kernel
Enabled;
CONFIG_ARM_APPENDED_DTB
CONFIG_ARM_ATAG_DTB_COMPAT
CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER

### Time measurements
Kernel to Userspace : Not meausered
Userspace to App    : Not measured

### Total size
50MB

----------------------- make xconfig
### Qt enabled
Enabled;
BR2_PACKAGE_QT5
BR2_PACKAGE_QT5BASE_EGLFS
BR2_PACKAGE_QT5BASE_FONTCONFIG
BR2_PACKAGE_QT5BASE_PNG
BR2_PACKAGE_QT5QUICKCONTROLS2
BR2_PACKAGE_QT5SERIALPORT
