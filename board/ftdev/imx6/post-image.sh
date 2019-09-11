#!/usr/bin/env bash

GENIMAGE_CFG="$(dirname $0)/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# zImage to uImage
mkimage -A arm -O linux -T kernel -C none -a 0x10008000 -e 0x10008000 -n "Linux kernel" -d ${BINARIES_DIR}/zImage ${BINARIES_DIR}/uImage

# copy the uEnv.txt to the output/images directory
cp board/ftdev/imx6/uEnv.txt $BINARIES_DIR/uEnv.txt

rm -rf "${GENIMAGE_TMP}"

# generate rootfs.img
genimage \
  --rootpath "${TARGET_DIR}" \
  --tmppath "${GENIMAGE_TMP}" \
  --inputpath "${BINARIES_DIR}" \
  --outputpath "${BINARIES_DIR}" \
  --config "${GENIMAGE_CFG}"

RET=${?}
exit ${RET}
