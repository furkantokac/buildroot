#!/bin/sh

die() {
	echo $1
	[ ! -z "${TMP_DIR}" ] && rm -rf "${TMP_DIR}"
	exit 1
}

_VERBOSE=0
log() {
	if [ "$_VERBOSE" -eq 1 ]; then
		echo "$@"
	fi
}

usage() {
	echo "Usage: $0 [options] <uboot-build-dir> <emmc-image> <output-file>"
	echo ""
	echo "Options:"
	echo "	-g <gpt-file>	Add u-boot cmds to write gpt partition table as specified in gpt-file"
	echo "	-d <dfu-map>	Add u-boot cmds to enter dfu-mode after flashing (dfu-map specifies dfu name to partition table mapping)"
	echo "	-e <extra-env>	Extra bootcmd options, executed before gpt; changes to the environment will be permanent"
	echo "	-v		Enable verbose output"
}

while getopts ":d:e:g:hv" opt; do
	case $opt in
		d)
			DFU_MAP=$OPTARG
			;;
		e)
			EXTRA_BOOTCMD=$OPTARG
			;;
		g)
			echo "Parse GPT file opt"
			GPT_FILE=$OPTARG
			;;
		h)
			usage
			exit 0
			;;
		v)
			_VERBOSE=1
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			echo ""
			usage
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			echo ""
			usage
			exit 1
			;;
	esac
done
shift "$(( OPTIND - 1 ))"

UBOOT_DIR=$1
EMMC_IMAGE=$2
OUT_FILE=$3

[ -d "${UBOOT_DIR}" ] || die "u-boot build directory ${UBOOT_DIR} does not exist."
[ -e "${EMMC_IMAGE}" ] || die "emmc image file ${EMMC_IMAGE} does not exist."

echo "Generate u-boot flasher image ${OUT_FILE}"

if [ ! -z "${GPT_FILE}" ]; then
	GPT_SPEC=$(cat "${GPT_FILE}")
	[ -z "${GPT_SPEC}" ] && die "Empty GPT table specified"
	echo "Using GPT_FILE: ${GPT_FILE}"
	GPT_BOOTCMD=$(cat <<-EOF
		echo >>> Write partition table to MMC
		gpt write mmc 0 '${GPT_SPEC}'
		mmc rescan
		EOF
	)
fi

if [ ! -z "${DFU_MAP}" ]; then
	echo "Use DFU_MAP \"${DFU_MAP}\""
	# For the dfu cmd, set dfu_alt_info in case EXTRA_BOOTCMD has
	# cleared it from the environment.
	DFU_BOOTCMD=$(cat <<-EOF
		setenv dfu_alt_info '${DFU_MAP}'
		echo >>> Enter DFU mode
		dfu 0 mmc 0
		EOF
	)
	PRE_SAVEENV_BOOTCMD=$(cat <<-EOF
		setenv dfu_alt_info '${DFU_MAP}'
		setenv dfucmd_mmc0 'dfu 0 mmc 0'
		EOF
	)
fi


# Collect information required to generate the flasher
LOADADDR=0x80108000
BSS_SIZE=$(size -A "${UBOOT_DIR}"/u-boot | grep ".bss\b" | tr -s ' ' | cut -d ' ' -f 2)
UBOOT_NODTB_TEGRA_SIZE=$(stat -c %s "${UBOOT_DIR}"/u-boot-nodtb-tegra.bin)
UBOOT_DTB_SIZE=$(stat -c %s "${UBOOT_DIR}"/u-boot.dtb)
UBOOT_PLUS_DTB_SIZE=$(( UBOOT_NODTB_TEGRA_SIZE + UBOOT_DTB_SIZE ))
IMG_SIZE=$(printf '0x%x' $(( ($(stat -c %s "${EMMC_IMAGE}") + 511) / 512 )) )

# Keep BSS area clear, acquire an extra 4kb for increased dtb, align to 4k
# boundary
PADDED_SIZE=$(( UBOOT_PLUS_DTB_SIZE + BSS_SIZE + 2 * 4 * 1024 - 1 & ~(4 * 1024 - 1) ))
IMG_ADDR=$(printf '0x%x' $(( LOADADDR + PADDED_SIZE )) )

log "UBOOT_NODTB_TEGRA_SIZE: ${UBOOT_NODTB_TEGRA_SIZE}"
log "UBOOT_DTB_SIZE: ${UBOOT_DTB_SIZE}"
log "UBOOT_PLUS_DTB_SIZE: ${UBOOT_PLUS_DTB_SIZE}"
log "BSS_SIZE: ${BSS_SIZE}"
log "PADDED_SIZE: ${PADDED_SIZE}"

UBOOT_FLASH_ENV=$(cat <<-EOF
	echo >>> Write image to MMC
	mmc dev 0 1
	mmc write ${IMG_ADDR} 0 ${IMG_SIZE}
	echo >>> Configure environment
	env default -f -a
	${PRE_SAVEENV_BOOTCMD}
	${EXTRA_BOOTCMD}
	saveenv
	${GPT_BOOTCMD}
	${DFU_BOOTCMD}
	echo >>> Resetting system
	reset
	EOF
)

# Generate the u-boot-flasher binary
TMP_DIR=$(mktemp -d) || die "Failed to create tmp directory"
DTB_FILE=${TMP_DIR}/u-boot-flasher.dtb
cp "${UBOOT_DIR}"/u-boot.dtb "${DTB_FILE}" || die "I/O error"
fdtput -p -t x "${DTB_FILE}" '/config' 'bootdelay' '0xfffffffe' || die "Failed to patch device-tree"
fdtput -p -t s "${DTB_FILE}" '/config' 'bootcmd' "${UBOOT_FLASH_ENV}" || die "Failed to patch device-tree"

FLASHER_FILE=${TMP_DIR}/u-boot-flasher.bin
cp "${UBOOT_DIR}"/u-boot-nodtb-tegra.bin "${FLASHER_FILE}" || die "I/O Error"
cat "${DTB_FILE}" >> "${FLASHER_FILE}" || die "I/O Error"
truncate -s ${PADDED_SIZE} "${FLASHER_FILE}" || die "Truncate failed"
cat "${EMMC_IMAGE}" >> "${FLASHER_FILE}" || die "Failed to append emmc image"
cp "${FLASHER_FILE}" "${OUT_FILE}" || die "Failed to install output file"

# Cleanup temp files
rm -rf "${TMP_DIR}"
