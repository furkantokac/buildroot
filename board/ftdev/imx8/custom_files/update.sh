#!/bin/sh

# Exit on error
set -e


###
### Params
### 
ROOTFS_PATH="/this/is/rootfs/dir/"
BOOT_PATH="/this/is/boot/dir/"

ROOTFS_TAR_FILE="rootfs.tar"

DEVICETREE_FILES="fsl-imx8qm-apalis-eval.dtb fsl-imx8qm-apalis-ixora-v1.1.dtb"
KERNEL_IMAGE="Image"
FIRMWARE_FILES="dpfw.bin hdmitxfw.bin boot.scr"

###
### -h
###
fun_printUsage()
{
    echo \
'### Usage ###
-r path : Update rootfs. Existing rootfs dir path is passed as argument.
-b path : Update boot. Existing boot dir path is passed as argument.
-h      : Print usage.

### Examples ###
Update rootfs           : ./update.sh -r "/this/is/rootfs/dir/"
Update boot partition   : ./update.sh -b "/this/is/boot/dir/"
Update both             : ./update.sh -r "/this/is/rootfs/dir/" -b "/this/is/boot/dir/"
Get help                : ./update.sh -h

### Explanation ###
1.  Connect your device to PC by MicroUSB.
2.  Boot your device to Uboot and enter the following command: ums 0 mmc 0
3.  On this stage, your device`s emmc should be shown on the PC as storage device.
4.  Enter rootfs and boot dir paths of device as parameter to the script as descibed on
    Examples section. Run the script in output/images/ dir.
5.  You can enter only rootfs or only boot or both.

### Tested Devices ###
* Apalis TK1 + Ixora
* Apalis iMX8 + Ixora';
}


###
### -r
###
fun_updateRootfs()
{
    sudo rm -rf $ROOTFS_PATH*
    sudo tar xf $ROOTFS_TAR_FILE -C $ROOTFS_PATH
}


###
### -b
###
fun_updateBoot()
{
    rm -rf $BOOT_PATH*
    cp $KERNEL_IMAGE $DEVICETREE_FILES $FIRMWARE_FILES $BOOT_PATH
}


###
### Main block
###
while getopts "r:b:h" OPT; do
    case $OPT in
        h)  fun_printUsage
            exit 0
            ;;
        r)  ROOTFS_PATH=$OPTARG
            fun_updateRootfs
            ;;
        b)  BOOT_PATH=$OPTARG
            fun_updateBoot
            ;;
    esac
done
