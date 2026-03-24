#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-env.sh"

ARTIFACT_DIR="${ROOT_DIR}/artifacts/tabor"
IMAGE_DIR="${ROOT_DIR}/artifacts/images"
IMAGE_PATH="${IMAGE_DIR}/tabor-a1222-wiki.img"
MOUNT_ROOT="${ROOT_DIR}/out/wikiimg"
BOOT_FILES_DIR="${MOUNT_ROOT}/bootfs"
ROOT_FILES_DIR="${MOUNT_ROOT}/rootfs"
BOOT_FS_IMAGE="${MOUNT_ROOT}/boot-partition.img"
ROOT_FS_IMAGE="${MOUNT_ROOT}/root-partition.img"
IMAGE_SIZE_MB="${A1222_WIKI_IMAGE_SIZE_MB:-1024}"
BOOT_MB="${A1222_WIKI_BOOT_MB:-128}"
ROOT_LABEL="${A1222_WIKI_ROOT_LABEL:-TABORROOT}"
BOOT_LABEL="${A1222_WIKI_BOOT_LABEL:-TABORBOOT}"
UIMAGE_SOURCE="${ARTIFACT_DIR}/uImage"
WRAPPED_UIMAGE_SOURCE="${ARTIFACT_DIR}/uImage.sdk17.2"
DTB_SOURCE="${ARTIFACT_DIR}/dtbs/fsl/tabor2.dtb"

if [[ ! -f "${WRAPPED_UIMAGE_SOURCE}" || ! -f "${DTB_SOURCE}" ]]; then
  echo "uImage.sdk17.2 or tabor2.dtb missing. Run ./scripts/package-kernel.sh first." >&2
  exit 1
fi

mkdir -p "${IMAGE_DIR}" "${BOOT_FILES_DIR}/boot" "${ROOT_FILES_DIR}/boot"
rm -f "${IMAGE_PATH}"

truncate -s "${IMAGE_SIZE_MB}M" "${IMAGE_PATH}"
parted -s "${IMAGE_PATH}" mklabel msdos
parted -s "${IMAGE_PATH}" unit MiB mkpart primary fat32 1 "${BOOT_MB}"
parted -s "${IMAGE_PATH}" set 1 boot on
parted -s "${IMAGE_PATH}" unit MiB mkpart primary ext2 "${BOOT_MB}" 100%

BOOT_START_SECTOR=$(parted -m "${IMAGE_PATH}" unit s print | awk -F: '$1 == "1" {gsub("s","",$2); print $2}')
BOOT_SECTORS=$(parted -m "${IMAGE_PATH}" unit s print | awk -F: '$1 == "1" {gsub("s","",$4); print $4}')
ROOT_START_SECTOR=$(parted -m "${IMAGE_PATH}" unit s print | awk -F: '$1 == "2" {gsub("s","",$2); print $2}')
ROOT_SECTORS=$(parted -m "${IMAGE_PATH}" unit s print | awk -F: '$1 == "2" {gsub("s","",$4); print $4}')

BOOT_OFFSET=$((BOOT_START_SECTOR * 512))
ROOT_OFFSET=$((ROOT_START_SECTOR * 512))
BOOT_SIZE_BYTES=$((BOOT_SECTORS * 512))
ROOT_SIZE_BYTES=$((ROOT_SECTORS * 512))

rm -rf "${BOOT_FILES_DIR}" "${ROOT_FILES_DIR}"
mkdir -p "${BOOT_FILES_DIR}/boot" "${ROOT_FILES_DIR}/boot"
rm -f "${BOOT_FS_IMAGE}" "${ROOT_FS_IMAGE}"

cp "${WRAPPED_UIMAGE_SOURCE}" "${BOOT_FILES_DIR}/uImage.sdk17.2"
cp "${DTB_SOURCE}" "${BOOT_FILES_DIR}/tabor2.dtb"
cp "${WRAPPED_UIMAGE_SOURCE}" "${ROOT_FILES_DIR}/boot/uImage.sdk17.2"
cp "${DTB_SOURCE}" "${ROOT_FILES_DIR}/boot/tabor2.dtb"

cat > "${ROOT_FILES_DIR}/README.rootfs.txt" <<EOF
This is a placeholder root filesystem partition for the wiki-style A1222 image.

The current image is intended to match the boot media shape from the wiki:
- FAT boot partition with uImage.sdk17.2 and tabor2.dtb
- second Linux partition intended to become /dev/sda2

It is not yet a full Debian or Gentoo userspace image.
EOF

truncate -s "${BOOT_SIZE_BYTES}" "${BOOT_FS_IMAGE}"
mkfs.vfat -F 32 -n "${BOOT_LABEL}" "${BOOT_FS_IMAGE}" > /dev/null
MTOOLS_SKIP_CHECK=1 mcopy -i "${BOOT_FS_IMAGE}" "${BOOT_FILES_DIR}/uImage.sdk17.2" ::/uImage.sdk17.2
MTOOLS_SKIP_CHECK=1 mcopy -i "${BOOT_FS_IMAGE}" "${BOOT_FILES_DIR}/tabor2.dtb" ::/tabor2.dtb

truncate -s "${ROOT_SIZE_BYTES}" "${ROOT_FS_IMAGE}"
mke2fs -q -t ext2 -L "${ROOT_LABEL}" -F "${ROOT_FS_IMAGE}"

dd if="${BOOT_FS_IMAGE}" of="${IMAGE_PATH}" bs=512 seek="${BOOT_START_SECTOR}" conv=notrunc status=none
dd if="${ROOT_FS_IMAGE}" of="${IMAGE_PATH}" bs=512 seek="${ROOT_START_SECTOR}" conv=notrunc status=none

cat > "${IMAGE_DIR}/tabor-a1222-wiki.txt" <<EOF
A1222 wiki-style image
======================

This image follows the public AmigaOne A1222 Linux wiki boot shape:
- FAT boot partition containing uImage.sdk17.2 and tabor2.dtb
- second Linux partition intended to appear as /dev/sda2

Manual boot sequence from A1222 prompt:
  setenv bootargs root=/dev/sda2 rootdelay=5
  fatload usb 0:1 1000000 uImage.sdk17.2
  fatload usb 0:1 2000000 tabor2.dtb
  bootm 1000000 - 2000000

This image is still a bring-up artifact:
- boot partition layout is now wiki-compatible
- second partition is a placeholder, not a full installed rootfs
- use it for boot path validation first
EOF

echo "Wiki-style A1222 image created at ${IMAGE_PATH}"
echo "Notes written to ${IMAGE_DIR}/tabor-a1222-wiki.txt"
