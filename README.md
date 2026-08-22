# Tabor Linux Forge

AUZiX-side source workbench for the A1222/Tabor Linux port.

This repository tracks the small, reviewable vendor enablement pieces first:

- `vendor/a-eon-5.4-rc3-a1222/tabor_5.4-1.patch`
- `vendor/a-eon-5.4-rc3-a1222/tabor3.dts`
- `vendor/a-eon-5.4-rc3-a1222/tabor-5.4-rc3.config`
- `vendor/a-eon-5.4-rc3-a1222/SHA256SUMS`

Generated or bulky source/build trees are intentionally ignored:

- `downloads/`
- `upstream/`
- `work/`
- `build/`
- `logs/`

## Current baseline

- Upstream kernel tag: `v5.4-rc3`
- Tagged commit: `4f5cafb5cb8471e54afdc9054d973535614f7675`
- Vendor archive filename: `linux-image-5.4-rc3-X1000_X5000_A1222.tar.gz`
- Archive reality: plain GNU/POSIX tar, not gzip

The initial vendor patch applies cleanly to upstream `v5.4-rc3` with `patch -p1`.

## Intended AUZiX direction

This is not meant to become a binary-module dump. The goal is a source-owned,
patch-tracked, reproducible AUZiX platform port:

1. preserve vendor evidence;
2. reproduce the 5.4-rc3 Tabor kernel;
3. split/review the board, DTS, and audio patches;
4. forward-port toward a Trixie-era kernel;
5. build an AUZiX PowerPC/SPE platform lane.

