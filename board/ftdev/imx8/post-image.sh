#!/bin/sh

# Copy files to output folder
cp ${BR2_EXTERNAL}/board/ftdev/imx8/custom_files/update.sh ${BINARIES_DIR}/
cp ${BR2_EXTERNAL}/board/ftdev/imx8/custom_files/boot_firmwares/* ${BINARIES_DIR}/
