#!/bin/bash

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"


###
### Create custom boot files with device tree appended to the zImage
###
echo "[7m>>>   Arranging fastboot files...[27m"

CUSTOM_CONFIG="${BOARD_DIR}/custom_files/config.txt"
CUSTOM_CMDLINE="${BOARD_DIR}/custom_files/cmdline.txt"
CUSTOM_BOOTCODE="${BINARIES_DIR}/rpi-firmware/bootcode.bin" # Using same bootcode.bin
CUSTOM_STARTELF="${BINARIES_DIR}/rpi-firmware/start.elf"    # Using same start.elf
CUSTOM_OUTPUT_DIR="${BINARIES_DIR}/custom"

# Find where is the DTB
if [ -f ${BINARIES_DIR}/bcm2710-rpi-3-b.dtb ]; then
    DTB_FILE="${BINARIES_DIR}/bcm2710-rpi-3-b.dtb"
else
    DTB_FILE="${BINARIES_DIR}/rpi-firmware/bcm2710-rpi-3-b.dtb"
fi

# Files will be copied to output folder
mkdir -p "${BINARIES_DIR}/custom"
cp "${CUSTOM_CONFIG}" "${CUSTOM_OUTPUT_DIR}/config.txt"
cp "${CUSTOM_CMDLINE}" "${CUSTOM_OUTPUT_DIR}/cmdline.txt"
cp "${CUSTOM_BOOTCODE}" "${CUSTOM_OUTPUT_DIR}/bootcode.bin"
cp "${CUSTOM_STARTELF}" "${CUSTOM_OUTPUT_DIR}/start.elf"

# Append device tree to img
cat "${BINARIES_DIR}/zImage" "${DTB_FILE}" > "${CUSTOM_OUTPUT_DIR}/zImagen"

echo "Fastboot files are ready."


###
### Generate image
###
echo "[7m>>>   Generating sdcard.img...[27m"

GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

echo "Sdcard.img is ready."


###
### Exit
###
exit $?
