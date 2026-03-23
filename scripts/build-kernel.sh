#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-env.sh"
JOBS="${JOBS:-$(nproc)}"

if [[ ! -f "${OUT_DIR}/.config" ]]; then
  echo "Kernel config missing. Run ./scripts/configure-tabor.sh first." >&2
  exit 1
fi

make -C "${KERNEL_DIR}" O="${OUT_DIR}" ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" -j"${JOBS}" zImage uImage modules dtbs

if [[ -n "${KERNEL_DTB_TARGETS}" ]]; then
  # Build board-relevant DTBs explicitly so we do not rely only on the generic
  # set implied by the current defconfig.
  make -C "${KERNEL_DIR}" O="${OUT_DIR}" ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" -j"${JOBS}" ${KERNEL_DTB_TARGETS}
fi

echo "Kernel build complete."
echo "Artifacts live under ${OUT_DIR}/arch/powerpc/boot and ${OUT_DIR}/arch/powerpc/boot/dts"
