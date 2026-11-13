---
name: tabor-port-pipeline
description: Maintain the Tabor Linux Forge Trixie powerpcspe distribution baseline, reviewed build exports, Debian packaging and staged boot validation. Compiler/backend defects remain in the authoritative toolchain project.
---
Read AGENTS.md, docs/trixie-spe-baseline.md and profiles/trixie-spe-baseline.json.
Reconcile retained results and active processes before issuing new work.

Target: P1022/e500v2, powerpcspe, powerpc-linux-gnuspe, ELF32 big endian,
SPE GPR floating point. GCC14 is required for target compilation and runtimes.
Preserve the qualified ABI flags (-mcpu=8548 -mabi=spe -mspe
-mfloat-gprs=double) and qualified long-double convention. Do not enable AltiVec
or classic FPR instructions. Kernel flags/configuration require their own recipe.
GCC8 outputs are historical bootstrap evidence, not final distribution artifacts.

Use Debian sbuild/apt/dpkg and clean buildd roots. Build amd64→powerpcspe with
cross,nocheck and only source-supported additional profiles. Native generators
and target development libraries are different roles; do not blanket-rewrite
Build-Depends with :native. Resolve real dependencies through package metadata.
Use supported bootstrap profiles to break demonstrated cycles and retain required
full rebuilds. Cache answers must come from measured target evidence.

Keep foundation development in amigaos-toolchain_patch. Import only reviewed,
commit/hash-pinned source/patch/configuration/build exports required by Forge.
A maintained ppc64el control can distinguish generic cross-build problems from
SPE-specific ones; it does not qualify the SPE ABI or physical board.

For measured work, fix the earliest shared failure, run a focused regression,
then a representative normal package build. Do not rerun deterministic failures
unchanged, regenerate accepted caches, or build a speculative dependency universe.
Use bounded remote jobs and retain evidence. Qualify GCC14 SDK/runtime packages
and clean roots before restarting the larger package closure; reject GCC8 or
unknown-compiler artifact reuse as final output.

Assemble the target root with apt/dpkg, preserving maintainer scripts/triggers.
Validate incrementally: installed shell/dpkg/apt/network/SSH, then software X/E,
then separate acceleration tests. Package counts are not an installed-system gate.
Record emulator limitations separately; do not suppress failing checks or claim
hardware acceptance from a build or QEMU run.

Before publication, include .agents/skills and .agents/prompts, verify references
and provenance, and remove secrets/local-machine details. Publish only when the
user requests it; this skill does not itself authorize publication.
