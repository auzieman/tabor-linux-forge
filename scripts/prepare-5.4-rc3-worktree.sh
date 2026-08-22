#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_DIR="${ROOT_DIR}/upstream/linux-5.4-rc3"
WORK_DIR="${ROOT_DIR}/work/linux-5.4-rc3-tabor"
PATCH_FILE="${ROOT_DIR}/vendor/a-eon-5.4-rc3-a1222/tabor_5.4-1.patch"
CONFIG_FILE="${ROOT_DIR}/vendor/a-eon-5.4-rc3-a1222/tabor-5.4-rc3.config"
DTS_FILE="${ROOT_DIR}/vendor/a-eon-5.4-rc3-a1222/tabor3.dts"

mkdir -p "${ROOT_DIR}/upstream" "${ROOT_DIR}/work" "${ROOT_DIR}/logs"

if [[ ! -d "${UPSTREAM_DIR}/.git" ]]; then
  git init "${UPSTREAM_DIR}"
  git -C "${UPSTREAM_DIR}" remote add origin https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  git -C "${UPSTREAM_DIR}" fetch --depth 1 origin tag v5.4-rc3
  git -C "${UPSTREAM_DIR}" checkout -q FETCH_HEAD
fi

if [[ ! -d "${WORK_DIR}" ]]; then
  cp -al "${UPSTREAM_DIR}" "${WORK_DIR}"
fi

git -C "${WORK_DIR}" checkout -q -- .
git -C "${WORK_DIR}" clean -fd >/dev/null

patch -d "${WORK_DIR}" -p1 < "${PATCH_FILE}"
mkdir -p "${WORK_DIR}/arch/powerpc/boot/dts"
cp -f "${DTS_FILE}" "${WORK_DIR}/arch/powerpc/boot/dts/tabor3.dts"
cp -f "${CONFIG_FILE}" "${WORK_DIR}/.config"

git -C "${WORK_DIR}" status --short > "${ROOT_DIR}/logs/worktree-status.txt"
printf 'Prepared %s\n' "${WORK_DIR}"
printf 'Status: %s\n' "${ROOT_DIR}/logs/worktree-status.txt"
