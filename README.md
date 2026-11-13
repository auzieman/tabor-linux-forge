# Tabor Linux Forge

Build and hardware-validation exports for A1222/Tabor Linux.

The SDK/toolchain and driver changes are authoritative in
[amigaos-toolchain_patch](https://github.com/auzieman/amigaos-toolchain_patch).
This forge consumes pinned exports with only the patches, configuration and
build instructions needed to reproduce a selected kernel experiment.

## Trixie / GCC14 distribution work

The first deliverable is a [complete Debian base boot image](docs/debian-base-image.md),
then software X11/Enlightenment as installable layers.

The next distribution baseline is **GCC14 / powerpcspe**. See the
[verified checkpoint and remaining gates](docs/trixie-spe-baseline.md),
[build skill](.agents/skills/tabor-port-pipeline/SKILL.md) and
[continuation prompts](.agents/prompts/resume-trixie-spe.md).
These workflow files are part of future reviewed source exports. The GCC14 SDK
and installed workstation are not yet release-qualified; earlier GCC8 packages
remain bootstrap history.

## Current experimental work

The `wip/polaris-be` branch now carries
[candidate007 and its physical console result](snapshots/polaris-be-20261108-e2e007/README.md).
The A1222 reaches readable1920x1080 HDMI text with `amdgpudrmfb` and bound fbcon;
SSH survives the driver load. The GFX indirect-buffer test still times out, so
this is **not a working accelerated desktop release**. The earlier
[2026-11-07 snapshot](snapshots/polaris-be-20261107/README.md) remains preserved.

Use a work branch for proposed changes and attach hardware validation to exact
commits and artifact hashes. Keep passing builds distinct from passing physical
hardware tests. See [contribution guidance](CONTRIBUTING.md).

## Historical vendor baseline

The material below documents the earlier source intake and remains preserved.


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


## Clean upstream comparison

[The7.3-rc6 clean GPU-source control](snapshots/upstream-clean-20261107/README.md)
compiled vmlinux, modules and A1222 DTBs successfully, with only board patches.
It has not been boot-tested and does not replace the earlier validation record.

AlpinE applications, utilities and artwork are staged as a source-port intake:
[desktop intake](docs/alpine-desktop-port.md),
[candidate inventory](profiles/alpine-desktop-port.json).


2026-11-13 update: [desktop/GPU checkpoint](docs/desktop-gpu-checkpoint-20261113.md) supersedes earlier pending/running status where noted. The build queue is idle/infrastructure-failed; the60FPS diagnostic cube does not establish installed desktop acceptance.
