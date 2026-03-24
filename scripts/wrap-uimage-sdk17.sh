#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <input-uimage> <output-wrapper>" >&2
  exit 1
fi

INPUT_IMAGE="$1"
OUTPUT_IMAGE="$2"
WRAP_OFFSET_HEX="${UIMAGE_WRAPPER_OFFSET_HEX:-0x440200}"
WRAP_OFFSET=$((WRAP_OFFSET_HEX))

if [[ ! -f "${INPUT_IMAGE}" ]]; then
  echo "Input uImage missing: ${INPUT_IMAGE}" >&2
  exit 1
fi

INPUT_SIZE=$(stat -c '%s' "${INPUT_IMAGE}")
OUTPUT_SIZE=$((WRAP_OFFSET + INPUT_SIZE))

rm -f "${OUTPUT_IMAGE}"
truncate -s "${OUTPUT_SIZE}" "${OUTPUT_IMAGE}"
dd if="${INPUT_IMAGE}" of="${OUTPUT_IMAGE}" bs=1 seek="${WRAP_OFFSET}" conv=notrunc status=none

echo "Wrapped ${INPUT_IMAGE} into ${OUTPUT_IMAGE} at offset ${WRAP_OFFSET_HEX}"
