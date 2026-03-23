#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-env.sh"
ARTIFACT_DIR="${ROOT_DIR}/artifacts/tabor"
BUNDLE_DIR="${ROOT_DIR}/artifacts/testbundle"
BOOT_DIR="${BUNDLE_DIR}/boot"
MENU_DIR="${BUNDLE_DIR}/menu"
KERNEL_IMAGE="${ARTIFACT_DIR}/zImage"
DTB_SOURCE="${ARTIFACT_DIR}/dtbs/fsl/tabor-a1222.dtb"
FALLBACK_DTB="${ARTIFACT_DIR}/dtbs/fsl/p1022ds_36b.dtb"
UIMAGE_SOURCE="${ARTIFACT_DIR}/uImage"

if [[ ! -f "${KERNEL_IMAGE}" ]]; then
  echo "Packaged kernel image missing. Run ./scripts/package-kernel.sh first." >&2
  exit 1
fi

mkdir -p "${BOOT_DIR}" "${MENU_DIR}"

cp "${KERNEL_IMAGE}" "${BOOT_DIR}/zImage"

if [[ -f "${UIMAGE_SOURCE}" ]]; then
  cp "${UIMAGE_SOURCE}" "${BOOT_DIR}/uImage"
fi

if [[ -f "${DTB_SOURCE}" ]]; then
  cp "${DTB_SOURCE}" "${BOOT_DIR}/tabor-a1222.dtb"
elif [[ -f "${FALLBACK_DTB}" ]]; then
  cp "${FALLBACK_DTB}" "${BOOT_DIR}/tabor-a1222.dtb"
else
  echo "No Tabor or fallback P1022 DTB found under ${ARTIFACT_DIR}/dtbs" >&2
  exit 1
fi

if [[ -f "${BOOT_DIR}/tabor-a1222.dtb" ]]; then
  cp "${BOOT_DIR}/tabor-a1222.dtb" "${BOOT_DIR}/tabor2.dtb"
fi

cp "${ROOT_DIR}/boot/README.boot.txt" "${BUNDLE_DIR}/README.boot.txt"
cp "${ROOT_DIR}/boot/boot.cmd.txt" "${MENU_DIR}/boot.cmd.txt"
cp "${ROOT_DIR}/boot/boot.scr.txt" "${MENU_DIR}/boot.scr.txt"

if [[ -f "${ARTIFACT_DIR}/kernel.release" ]]; then
  cp "${ARTIFACT_DIR}/kernel.release" "${BUNDLE_DIR}/kernel.release"
fi

echo "Test bundle staged under ${BUNDLE_DIR}"
