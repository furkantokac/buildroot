#!/bin/sh


# zImage to uImage
mkimage -A arm -O linux -T kernel -C none -a 0x10008000 -e 0x10008000 -n "Linux kernel" -d ${BINARIES_DIR}/zImage ${BINARIES_DIR}/uImage


# Copy files to output folder
cp board/ftdev/tk1/update.sh ${BINARIES_DIR}/
cp board/ftdev/tk1/docs/001-lvds-xorg/001-tegra124-apalis-eval.dtb ${BINARIES_DIR}/tegra124-apalis-eval.dtb
