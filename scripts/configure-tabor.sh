#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-env.sh"
CONFIG_SERIES_FILE="${ROOT_DIR}/${KERNEL_CONFIG_SERIES}"

if [[ ! -d "${KERNEL_DIR}" ]]; then
  echo "Kernel tree missing. Run ./scripts/fetch-linux.sh first." >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"

make -C "${KERNEL_DIR}" O="${OUT_DIR}" ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" mpc85xx_defconfig

if [[ -f "${CONFIG_SERIES_FILE}" ]]; then
  mapfile -t CONFIGS < <("${ROOT_DIR}/scripts/resolve-series.sh" "${CONFIG_SERIES_FILE}")
  if [[ ${#CONFIGS[@]} -gt 0 ]]; then
    "${KERNEL_DIR}/scripts/kconfig/merge_config.sh" -m -O "${OUT_DIR}" "${OUT_DIR}/.config" "${CONFIGS[@]}"
  fi
  make -C "${KERNEL_DIR}" O="${OUT_DIR}" ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" olddefconfig
fi

echo "Configured kernel output in ${OUT_DIR}"
