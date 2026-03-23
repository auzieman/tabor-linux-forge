#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/kernel-env.sh"
PATCH_DIR="${ROOT_DIR}/patches"
STAMP_FILE="${ROOT_DIR}/out/tabor/.patches-applied"
SERIES_FILE="${ROOT_DIR}/${KERNEL_PATCH_SERIES}"

if [[ ! -d "${KERNEL_DIR}/.git" ]]; then
  if [[ ! -d "${KERNEL_DIR}" ]]; then
    echo "Kernel tree missing. Run ./scripts/fetch-linux.sh first." >&2
    exit 1
  fi
fi

if [[ ! -f "${SERIES_FILE}" ]]; then
  echo "Patch series file missing: ${KERNEL_PATCH_SERIES}" >&2
  exit 1
fi

mkdir -p "$(dirname "${STAMP_FILE}")"

if [[ -f "${STAMP_FILE}" ]]; then
  echo "Patches already applied for this output tree. Remove ${STAMP_FILE} to reapply." >&2
  exit 0
fi

mapfile -t PATCHES < <("${ROOT_DIR}/scripts/resolve-series.sh" "${SERIES_FILE}")

if [[ ${#PATCHES[@]} -eq 0 ]]; then
  echo "Patch series is empty; nothing to apply."
  exit 0
fi

for patch in "${PATCHES[@]}"; do
  if [[ ! -f "${patch}" ]]; then
    echo "Patch not found: ${patch}" >&2
    exit 1
  fi
  echo "Applying $(basename "${patch}")"
  (
    cd "${KERNEL_DIR}"
    git apply --check "${patch}"
    git apply "${patch}"
  )
done

date -u +"%Y-%m-%dT%H:%M:%SZ" > "${STAMP_FILE}"
echo "Patch application complete."
