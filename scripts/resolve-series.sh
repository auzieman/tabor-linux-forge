#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

resolve_file() {
  local series_file="$1"
  local base_dir
  base_dir="$(dirname "${series_file}")"

  while IFS= read -r raw_line || [[ -n "${raw_line}" ]]; do
    local line
    line="${raw_line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    [[ -z "${line}" ]] && continue

    if [[ "${line}" == include\ * ]]; then
      local nested_rel="${line#include }"
      local nested
      if [[ "${nested_rel}" = /* ]]; then
        nested="${nested_rel}"
      else
        nested="${ROOT_DIR}/${nested_rel}"
        if [[ ! -f "${nested}" ]]; then
          nested="${base_dir}/${nested_rel}"
        fi
      fi
      if [[ ! -f "${nested}" ]]; then
        echo "Included series file not found: ${nested_rel}" >&2
        exit 1
      fi
      resolve_file "${nested}"
      continue
    fi

    if [[ "${line}" = /* ]]; then
      printf '%s\n' "${line}"
    else
      local candidate="${ROOT_DIR}/${line}"
      if [[ -f "${candidate}" ]]; then
        printf '%s\n' "${candidate}"
      else
        printf '%s\n' "${base_dir}/${line}"
      fi
    fi
  done < "${series_file}"
}

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <series-file>" >&2
  exit 1
fi

SERIES_INPUT="$1"
if [[ "${SERIES_INPUT}" = /* ]]; then
  SERIES_PATH="${SERIES_INPUT}"
else
  SERIES_PATH="${ROOT_DIR}/${SERIES_INPUT}"
fi

if [[ ! -f "${SERIES_PATH}" ]]; then
  echo "Series file not found: ${SERIES_INPUT}" >&2
  exit 1
fi

resolve_file "${SERIES_PATH}"
