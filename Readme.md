# Tabor Linux Forge

A build and experimentation environment for running Linux on unsupported and niche PowerPC hardware, starting with the Amiga A1222 (Tabor).

## Goals

- Re-enable modern Linux workflows on SPE-based PowerPC systems
- Provide reproducible toolchains and build environments
- Explore Gentoo-based source builds for maximum flexibility
- Keep systems minimal, fast, and hardware-aware

## Philosophy

This project does not attempt to revive legacy distributions.

Instead, it builds a new path forward using:
- modern tooling
- controlled build environments (Docker)
- source-based systems

## Status

Kernel bootstrap phase.

## Targets

- A1222 (Tabor, e500v2 / SPE)
- Additional PPC and niche boards in the future

## Current Kernel Flow

This repo now has a concrete kernel build path aimed at getting to testable boot artifacts quickly:

1. select a kernel source profile
2. fetch the matching Linux tree
3. optionally apply Gentoo and local Tabor patches through ordered series files
3. configure from `mpc85xx_defconfig` plus a Tabor-oriented config overlay
4. build `zImage`, modules, and device trees
5. package artifacts under `artifacts/tabor/`

This is intentionally honest about the current state: the workflow is real, but Tabor-specific DTS and downstream patch work may still be needed before the board actually boots a mainline-based image cleanly.

## Requirements

- Docker Compose for the default build path
- or a native Linux host with a `powerpc-linux-gnu-` cross toolchain

## Profiles

Kernel source selection now lives under `profiles/kernel/`.

Shipped profiles:

- `profiles/kernel/upstream-6.6-lts.env`
- `profiles/kernel/upstream-6.12-lts.env`

Example Gentoo-oriented profiles:

- `profiles/kernel/gentoo-6.6-lts.example.env`
- `profiles/kernel/gentoo-6.12-lts.example.env`

Recommended starting point:

- `6.6 LTS` if the goal is the safest first hardware bring-up
- `6.12 LTS` if you want to stay closer to Gentoo’s currently active ppc distribution-kernel line

## Quick Start

Build the container:

```bash
make container
```

Fetch the kernel tree:

```bash
make fetch KERNEL_PROFILE=profiles/kernel/upstream-6.6-lts.env
```

Apply any local patches from `patches/`:

```bash
make patch
```

Configure the kernel:

```bash
make configure
```

Build the kernel artifacts:

```bash
make kernel
```

Package them for inspection or handoff to boot media:

```bash
make package
```

Stage a non-destructive USB test bundle:

```bash
make testbundle
```

Build a `dd`-able FAT USB image from that bundle:

```bash
make usbimg
```

Build an experimental A1222-native raw image with `tabor2.dtb` and `uImage`
at forum-reported SD/MMC block offsets:

```bash
make nativeimg
```

The resulting files land under:

- `artifacts/tabor/zImage`
- `artifacts/tabor/dtbs/`
- `artifacts/tabor/modules/`
- `artifacts/testbundle/`
- `artifacts/images/tabor-linux.img`
- `artifacts/images/tabor-a1222-native.img`

All normal fetch/configure/build/package actions now run through the root-level Compose file at [docker-compose.yml](/home/auzieman/Projects/tabor-linux-forge/docker-compose.yml), which keeps the toolchain pinned and avoids polluting the host with build dependencies.

## Working Inside The Container

Open a shell in the build image:

```bash
make shell
```

Inside the container, you can run the scripts directly:

```bash
./scripts/fetch-linux.sh profiles/kernel/upstream-6.6-lts.env
./scripts/apply-patches.sh
./scripts/configure-tabor.sh
./scripts/build-kernel.sh
./scripts/package-kernel.sh
```

## Kernel Configuration Notes

The kernel config starts from `mpc85xx_defconfig` and layers the ordered fragments from `configs/series.tabor` on top. That overlay currently biases toward:

- e500v2 / SPE support
- Freescale networking
- serial console bring-up
- ext4 and initrd-based bring-up
- early Radeon-era graphics as a later-stage convenience

## SPE Expectations

The current kernel build enables the CPU-family side needed for Tabor-class bring-up:

- `CONFIG_SPE=y`
- `CONFIG_SPE_POSSIBLE=y`
- `CONFIG_FSL_SOC_BOOKE=y`
- `CONFIG_P1022_DS=y`

That is enough to say the kernel is targeting the right Book-E / SPE family.

It does **not** yet mean:

- Tabor board support is complete
- userspace SPE policy is finalized
- floating-point edge cases are fully validated on real hardware

The current expectation is:

- kernel boots far enough for serial validation
- board DTS and boot handoff are still under active refinement
- userspace choices remain open after kernel bring-up

## Patch Strategy

Patch selection now uses series files:

- `patches/series`
- `patches/series.local`
- `patches/series.gentoo-6.6`
- `patches/series.gentoo-6.12`

Config layering uses the same pattern:

- `configs/series.tabor`
- `configs/series.local`
- `configs/fragments/tabor-core.cfg`

That lets you combine:

- upstream stable
- Gentoo-style patch layers
- local board patches
- local one-off config fragments

without rewriting the build scripts.

Local board work belongs in `patches/`.

That keeps the workflow clean:

- upstream stable kernel in `build/linux`
- local board deltas as reviewable patch files
- packaged outputs under `artifacts/tabor`

## Repo Footprint

The repo is set up to keep large transient data out of Git:

- source trees in `build/`
- downloaded tarballs in `downloads/`
- intermediate build output in `out/`
- packaged artifacts in `artifacts/`

Those paths are ignored in [.gitignore](/home/auzieman/Projects/tabor-linux-forge/.gitignore), and they are also excluded from Docker build context in [.dockerignore](/home/auzieman/Projects/tabor-linux-forge/.dockerignore).

## Gentoo Notes

The repo does not hardcode a single Gentoo patch tarball yet. Instead, the example Gentoo profiles and series files give you a repeatable place to stage the exact source tarball and extracted patch members you want to test. That is intentional, because Tabor bring-up will likely require trying a conservative longterm base first and then adjusting the Gentoo layer on top.

## Current Tabor DTS Strategy

The local patch stack now stages a minimal board DTS at:

- `arch/powerpc/boot/dts/fsl/tabor-a1222.dts`

That DTS is intentionally conservative and currently derives from the upstream `p1022ds_36b.dts` path. It is a starting point for real board bring-up, not a final hardware description.

## Test Bundle Strategy

The first board-facing target is a non-destructive USB test bundle, not a full installed system image.

`make testbundle` stages:

- a kernel image
- a Tabor-targeted DTB
- simple boot notes and manual U-Boot command examples

That keeps the early validation loop safe:

- no disk overwrite
- no replacement of the current OS
- serial-console-first testing

## USB Boot Notes

The staged bundle currently contains:

- `artifacts/testbundle/boot/zImage`
- `artifacts/testbundle/boot/uImage`
- `artifacts/testbundle/boot/tabor-a1222.dtb`
- `artifacts/testbundle/boot/tabor2.dtb`
- `artifacts/testbundle/menu/boot.cmd.txt`
- `artifacts/testbundle/menu/boot.scr.txt`

The intended first-pass workflow is:

1. format a USB stick with a simple FAT partition
2. copy the bundle contents onto it
3. enter the A1222 firmware / U-Boot environment
4. load the kernel and DTB manually first
5. keep the installed disk OS untouched during bring-up

The bundled `boot.cmd.txt` is only an example. Memory addresses and USB device numbering may need to be adjusted to match the actual A1222 firmware environment.

If you prefer a single image file, `make usbimg` creates a FAT-formatted superfloppy image at:

- `artifacts/images/tabor-linux.img`

You can write it with:

```bash
sudo dd if=artifacts/images/tabor-linux.img of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `/dev/sdX` with the actual USB device.

## A1222 Native Image

`make nativeimg` creates an experimental raw image at:

- `artifacts/images/tabor-a1222-native.img`

It currently stages:

- `tabor2.dtb`
- `uImage`

using these default block offsets:

- DTB at `0x32000`
- kernel at `0x35000`

Those offsets are based on user-reported working A1222/Tabor layouts from the
Amigans forum thread and should be treated as an experimental native-boot path,
not a finished release image.

At this stage, success means:

- serial console output appears
- the kernel image starts reliably
- the DTB is accepted
- early CPU, memory, and device initialization does not fault immediately

It does **not** yet require:

- full graphics bring-up
- writable rootfs
- replacement of the installed operating system
- a finished installer image

## Next Steps

- identify or author a Tabor-specific DTS path
- validate boot expectations with the board firmware and U-Boot flow
- add a tiny initramfs for non-destructive shell and benchmark booting
- produce a minimal root filesystem
- add a first serial-console boot checklist
