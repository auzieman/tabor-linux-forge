#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT_DIR}/scripts/load-kernel-profile.sh" "${1:-${KERNEL_PROFILE:-profiles/kernel/upstream-6.6-lts.env}}"
KERNEL_DIR="${ROOT_DIR}/build/linux"
DOWNLOAD_DIR="${ROOT_DIR}/downloads"

mkdir -p "${ROOT_DIR}/build" "${DOWNLOAD_DIR}"

case "${KERNEL_SOURCE_KIND}" in
  git)
    if [[ -z "${KERNEL_GIT_URL:-}" || -z "${KERNEL_REF:-}" ]]; then
      echo "Git profile requires KERNEL_GIT_URL and KERNEL_REF." >&2
      exit 1
    fi
    if [[ ! -d "${KERNEL_DIR}/.git" ]]; then
      git clone --depth 1 --branch "${KERNEL_REF}" "${KERNEL_GIT_URL}" "${KERNEL_DIR}"
    else
      git -C "${KERNEL_DIR}" reset --hard HEAD
      git -C "${KERNEL_DIR}" clean -fd
      git -C "${KERNEL_DIR}" fetch --depth 1 origin "${KERNEL_REF}"
      git -C "${KERNEL_DIR}" checkout "${KERNEL_REF}"
    fi
    ;;
  tarball)
    if [[ -z "${KERNEL_TARBALL_URL:-}" || -z "${KERNEL_TARBALL_NAME:-}" ]]; then
      echo "Tarball profile requires KERNEL_TARBALL_URL and KERNEL_TARBALL_NAME." >&2
      exit 1
    fi
    ARCHIVE_PATH="${DOWNLOAD_DIR}/${KERNEL_TARBALL_NAME}"
    rm -rf "${KERNEL_DIR}"
    wget -O "${ARCHIVE_PATH}" "${KERNEL_TARBALL_URL}"
    mkdir -p "${KERNEL_DIR}"
    tar -xf "${ARCHIVE_PATH}" --strip-components=1 -C "${KERNEL_DIR}"
    ;;
  *)
    echo "Unsupported KERNEL_SOURCE_KIND: ${KERNEL_SOURCE_KIND}" >&2
    exit 1
    ;;
esac

echo "Kernel source ready at ${KERNEL_DIR} using profile ${PROFILE_NAME}"
