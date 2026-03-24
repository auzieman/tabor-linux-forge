# Tabor Linux Forge Specification

## Overview

Tabor Linux Forge is a build and experimentation environment for running Linux on niche and unsupported PowerPC hardware, starting with the Amiga A1222 (Tabor).

The project focuses on:
- reproducible build workflows
- source-based system construction
- SPE-aware toolchain exploration
- minimal, hardware-appropriate Linux environments
- future expansion to additional PowerPC boards

## Initial Target

- Board: Amiga A1222 / Tabor
- CPU class: e500v2 / SPE
- RAM target: 8 GB
- Graphics target: older ATI Radeon
- System profile: thin, responsive, minimal desktop and development environment

## Philosophy

This project does not attempt to revive legacy distributions as-is.

Instead, it uses modern build workflows to create a practical Linux path for hardware that is no longer well supported by mainstream distributions.

## Near-Term Goals

1. Establish reproducible Docker-based build tooling
2. Build a repeatable kernel workflow around upstream stable plus local patches
3. Bootstrap a Gentoo-oriented source build workflow
4. Produce a minimal root filesystem
5. Reach a reliable shell + networking + package workflow
6. Add lightweight graphics and desktop support later

## Deferred Goals

- Full desktop environment optimization
- MATE evaluation
- Multi-board support
- Custom higher-level tooling for repeatable board builds

## Current Build Design

The first concrete implementation target is the kernel build path.

The repo should support:

1. selecting a named kernel source profile
2. fetching a known Linux stable tree or tarball
3. applying ordered patch series, including Gentoo-style layers plus local Tabor deltas
4. configuring from `mpc85xx_defconfig` plus ordered config fragments
5. building `zImage`, modules, and DTBs with a reproducible container
6. packaging outputs under `artifacts/tabor/`

This keeps the early work grounded in a testable loop without pretending that the upstream tree already contains complete A1222 support.

## Kernel Assumptions

- Base architecture: `powerpc`
- CPU family: e500 / MPC85xx class
- Toolchain direction: `powerpc-linux-gnu-` first for kernel work
- Later userspace work may require stricter SPE-aware toolchain handling
- The first two practical baselines are `6.6 LTS` and `6.12 LTS`

## Board-Specific Reality

Tabor support is expected to need one or more of:

- a board-specific DTS
- small platform patches
- bootloader argument validation
- serial-console-first bring-up

That work should be staged as reviewable local patches rather than hidden in ad hoc source edits.

## Source Baseline Strategy

Near-term, the project should support two tracks:

1. `Upstream 6.6 LTS`
   Conservative bring-up track for first successful boots and serial validation.

2. `Gentoo-aligned 6.12 LTS`
   Newer distribution-kernel track for later integration with Gentoo-oriented userspace and patching habits.

Those tracks should share the same local Tabor patch and config layering model so they remain comparable.

## Immediate Milestones

1. Build bootable kernel artifacts from the container workflow
2. Establish the correct DTS / boot handoff for A1222
3. Reproduce the board-specific boot wrapper expected by shipped A1222 images
4. Validate serial output on real hardware
5. Add minimal rootfs generation
6. Move on to networking and package-management bring-up

## Gentoo Direction

Gentoo remains an intended target userspace path, but it should not currently
drive the boot-format work.

The observed Debian `powerpcspe` image suggests:

- boot compatibility is the immediate blocker
- the root filesystem can remain comparatively conventional
- the real mystery is the wrapped kernel boot artifact and firmware interaction

So the near-term strategy is:

1. reproduce the known-good boot wrapper behavior
2. keep rootfs generation simple and pragmatic
3. revisit Gentoo once the board boots reliably from reproducible media
