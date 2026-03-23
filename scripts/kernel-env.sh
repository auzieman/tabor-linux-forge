#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export ROOT_DIR
source "${ROOT_DIR}/scripts/load-kernel-profile.sh" "${KERNEL_PROFILE:-profiles/kernel/upstream-6.6-lts.env}"
export KERNEL_DIR="${ROOT_DIR}/build/linux"
export OUT_DIR="${ROOT_DIR}/out/tabor"
export ARCH="${ARCH:-powerpc}"
export CROSS_COMPILE="${CROSS_COMPILE:-powerpc-linux-gnu-}"
