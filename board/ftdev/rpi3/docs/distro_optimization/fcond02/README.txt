----------------------- make kernel-xconfig
### Networking disabled
Disabled;
CONFIG_NET

### Sound disabled
Disabled;
CONFIG_SOUND

### File systems optimized
Summary;
Especially Ext4, journal etc.

### USB OTG disabled
Summary;
Usb doesnt working now but kernel boot time is improved more than 1 second.
Disabled;
CONFIG_USB_DWCOTG

### Time measurements
Kernel to Userspace : Not meausered
Userspace to App    : Not measured
Total boot time     : 3.10sec
