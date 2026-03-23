#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-env.sh"

BUNDLE_DIR="${ROOT_DIR}/artifacts/testbundle"
IMAGE_DIR="${ROOT_DIR}/artifacts/images"
IMAGE_PATH="${IMAGE_DIR}/tabor-linux.img"
IMAGE_SIZE_MB="${USB_IMAGE_SIZE_MB:-128}"

if [[ ! -d "${BUNDLE_DIR}" ]]; then
  echo "Test bundle missing. Run ./scripts/build-testbundle.sh first." >&2
  exit 1
fi

mkdir -p "${IMAGE_DIR}"
rm -f "${IMAGE_PATH}"

truncate -s "${IMAGE_SIZE_MB}M" "${IMAGE_PATH}"
mkfs.vfat -F 32 -n TABORTEST "${IMAGE_PATH}" > /dev/null

# mtools can write directly to the FAT image without loop mounts.
mmd -i "${IMAGE_PATH}" ::/boot
mmd -i "${IMAGE_PATH}" ::/menu

mcopy -i "${IMAGE_PATH}" "${BUNDLE_DIR}/README.boot.txt" ::/README.boot.txt
mcopy -i "${IMAGE_PATH}" "${BUNDLE_DIR}/kernel.release" ::/kernel.release 2>/dev/null || true
mcopy -i "${IMAGE_PATH}" "${BUNDLE_DIR}/boot/"* ::/boot/
mcopy -i "${IMAGE_PATH}" "${BUNDLE_DIR}/menu/"* ::/menu/

echo "USB image created at ${IMAGE_PATH}"
echo "Write it with: sudo dd if=${IMAGE_PATH} of=/dev/sdX bs=4M status=progress conv=fsync"
