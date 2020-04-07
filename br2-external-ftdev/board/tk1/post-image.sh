#!/bin/sh


# zImage to uImage
mkimage -A arm -O linux -T kernel -C none -a 0x10008000 -e 0x10008000 -n "Linux kernel" -d ${BINARIES_DIR}/zImage ${BINARIES_DIR}/uImage


# Backup original files
mv ${BINARIES_DIR}/tegra124-apalis-eval.dtb ${BINARIES_DIR}/tegra124-apalis-eval.original.dtb


# Copy files to output folder
cp ${BR2_EXTERNAL}/board/tk1/custom_files/update.sh ${BINARIES_DIR}/
cp ${BR2_EXTERNAL}/board/tk1/custom_files/tegra124-apalis-eval-current.dtb ${BINARIES_DIR}/tegra124-apalis-eval.dtb
