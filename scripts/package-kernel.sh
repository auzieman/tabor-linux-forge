#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-env.sh"
ARTIFACT_DIR="${ROOT_DIR}/artifacts/tabor"
KERNEL_IMAGE="${OUT_DIR}/arch/powerpc/boot/zImage"
UIMAGE_SOURCE="${OUT_DIR}/arch/powerpc/boot/uImage"
DTB_DIR="${OUT_DIR}/arch/powerpc/boot/dts"
MODULES_DIR="${ARTIFACT_DIR}/modules"
VERSION_FILE="${OUT_DIR}/include/config/kernel.release"

if [[ ! -f "${KERNEL_IMAGE}" ]]; then
  echo "Kernel image missing. Run ./scripts/build-kernel.sh first." >&2
  exit 1
fi

mkdir -p "${ARTIFACT_DIR}" "${MODULES_DIR}"

cp "${KERNEL_IMAGE}" "${ARTIFACT_DIR}/"

if [[ -f "${UIMAGE_SOURCE}" ]]; then
  cp "${UIMAGE_SOURCE}" "${ARTIFACT_DIR}/"
fi

if [[ -d "${DTB_DIR}" ]]; then
  rsync -a \
    --delete \
    --prune-empty-dirs \
    --include='*/' \
    --include='*.dtb' \
    --exclude='*' \
    "${DTB_DIR}/" "${ARTIFACT_DIR}/dtbs/"
fi

if [[ -f "${ARTIFACT_DIR}/dtbs/fsl/tabor-a1222.dtb" ]]; then
  cp "${ARTIFACT_DIR}/dtbs/fsl/tabor-a1222.dtb" "${ARTIFACT_DIR}/dtbs/fsl/tabor2.dtb"
elif [[ -f "${ARTIFACT_DIR}/dtbs/fsl/p1022ds_36b.dtb" ]]; then
  cp "${ARTIFACT_DIR}/dtbs/fsl/p1022ds_36b.dtb" "${ARTIFACT_DIR}/dtbs/fsl/tabor2.dtb"
fi

make -C "${KERNEL_DIR}" O="${OUT_DIR}" ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" modules_install INSTALL_MOD_PATH="${MODULES_DIR}" > /dev/null

if [[ -f "${VERSION_FILE}" ]]; then
  cp "${VERSION_FILE}" "${ARTIFACT_DIR}/kernel.release"
fi

echo "Packaged artifacts under ${ARTIFACT_DIR}"
