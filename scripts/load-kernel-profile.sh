#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
PROFILE_PATH_INPUT="${1:-${KERNEL_PROFILE:-profiles/kernel/upstream-6.6-lts.env}}"

if [[ "${PROFILE_PATH_INPUT}" = /* ]]; then
  PROFILE_PATH="${PROFILE_PATH_INPUT}"
else
  PROFILE_PATH="${ROOT_DIR}/${PROFILE_PATH_INPUT}"
fi

if [[ ! -f "${PROFILE_PATH}" ]]; then
  echo "Kernel profile not found: ${PROFILE_PATH_INPUT}" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "${PROFILE_PATH}"

export PROFILE_PATH
export PROFILE_NAME="${PROFILE_NAME:-custom}"
export KERNEL_SOURCE_KIND="${KERNEL_SOURCE_KIND:-git}"
export KERNEL_PATCH_SERIES="${KERNEL_PATCH_SERIES:-patches/series}"
export KERNEL_CONFIG_SERIES="${KERNEL_CONFIG_SERIES:-configs/series.tabor}"
export KERNEL_DTB_TARGETS="${KERNEL_DTB_TARGETS:-}"
export KERNEL_UBOOT_IMAGE_TARGET="${KERNEL_UBOOT_IMAGE_TARGET:-}"
