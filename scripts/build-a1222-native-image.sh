#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-env.sh"

ARTIFACT_DIR="${ROOT_DIR}/artifacts/tabor"
IMAGE_DIR="${ROOT_DIR}/artifacts/images"
IMAGE_PATH="${IMAGE_DIR}/tabor-a1222-native.img"
README_PATH="${IMAGE_DIR}/tabor-a1222-native.txt"
SECTOR_SIZE="${A1222_SECTOR_SIZE:-512}"
DTB_BLOCK="${A1222_DTB_BLOCK:-0x32000}"
UIMAGE_BLOCK="${A1222_UIMAGE_BLOCK:-0x35000}"
IMAGE_SIZE_MB="${A1222_NATIVE_IMAGE_SIZE_MB:-128}"
DTB_PATH="${ARTIFACT_DIR}/dtbs/fsl/tabor2.dtb"
UIMAGE_PATH="${ARTIFACT_DIR}/uImage"

if [[ ! -f "${UIMAGE_PATH}" ]]; then
  echo "uImage missing. Run ./scripts/package-kernel.sh first." >&2
  exit 1
fi

if [[ ! -f "${DTB_PATH}" ]]; then
  echo "tabor2.dtb missing. Run ./scripts/package-kernel.sh first." >&2
  exit 1
fi

mkdir -p "${IMAGE_DIR}"
rm -f "${IMAGE_PATH}" "${README_PATH}"

truncate -s "${IMAGE_SIZE_MB}M" "${IMAGE_PATH}"

dtb_seek=$((DTB_BLOCK))
uimage_seek=$((UIMAGE_BLOCK))

dd if="${DTB_PATH}" of="${IMAGE_PATH}" bs="${SECTOR_SIZE}" seek="${dtb_seek}" conv=notrunc status=none
dd if="${UIMAGE_PATH}" of="${IMAGE_PATH}" bs="${SECTOR_SIZE}" seek="${uimage_seek}" conv=notrunc status=none

cat > "${README_PATH}" <<EOF
A1222 native image
==================

This raw image stages:
- tabor2.dtb at block ${DTB_BLOCK}
- uImage at block ${UIMAGE_BLOCK}

Defaults:
- sector size: ${SECTOR_SIZE}
- image size: ${IMAGE_SIZE_MB} MiB

These offsets are based on forum-reported working layouts for A1222/Tabor
manual boot testing. They should be treated as an experimental compatibility
path, not a fully validated release installer image.

Write with:
  sudo dd if=${IMAGE_PATH} of=/dev/sdX bs=4M status=progress conv=fsync

Then boot from firmware/U-Boot using the board's native Linux boot flow.
EOF

echo "A1222 native image created at ${IMAGE_PATH}"
echo "Layout notes written to ${README_PATH}"
