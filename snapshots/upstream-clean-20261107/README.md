# Clean upstream AMDGPU kernel control — 2026-11-07

**Compiled successfully; not boot-tested.** This control uses GitLab AMDGPU
commit5349075eac146ae0511d8929fc24451e4d9a4b7e (Linux7.3-rc6), with only the
two A1222 board patches retained here. No experimental GPU patches and no
changes under drivers/gpu. Full vmlinux/modules/dtbs build exited0, producing
an ELF32 big-endian PowerPC kernel and42 modules. AMDGPU vermagic matches
7.3.0-rc6-tabor-upstream-001. Exact hashes are in manifest.json.

Canonical development remains in amigaos-toolchain_patch, commit389851a.
This is a consumer snapshot, not an independently maintained SDK/driver fork.
The earlier6.12 experimental snapshot and its failed hardware results remain
preserved. A later successful boot of this newer kernel would not, by itself,
identify which older patch or upstream change explains the prior fault.

## Standard build recipe

Use the qualified shared read-only compiler environment (GCC14.2.0-19,
binutils2.44 and normal kernel prerequisites), cached Git source and an empty
output directory. Verify this snapshot's patch/config SHA256 against the
manifest before applying. The lab build was bounded to4CPUs/6GiB, network disabled
after source intake. The retained image digest identifies the lab environment;
it is not a public image download location.

```sh
# Run from the cached clone to materialize a fresh checkout of the pinned commit.
git worktree add --detach /work/source 5349075eac146ae0511d8929fc24451e4d9a4b7e
git -C /work/source sparse-checkout disable
cd /work/source
# Use the absolute path of this exported snapshot as SNAPSHOT_DIR.
git apply --check "$SNAPSHOT_DIR/patches/0001-powerpc-tabor-initial-machine-dts.patch"
git apply "$SNAPSHOT_DIR/patches/0001-powerpc-tabor-initial-machine-dts.patch"
git apply --check "$SNAPSHOT_DIR/patches/0002-powerpc-tabor-match-vendor-compatible.patch"
git apply "$SNAPSHOT_DIR/patches/0002-powerpc-tabor-match-vendor-compatible.patch"
mkdir /work/output
cp "$SNAPSHOT_DIR/kernel.config" /work/output/.config
make O=/work/output ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu- olddefconfig
make O=/work/output ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu- -j4 vmlinux modules dtbs
```

The retained config already has the distinct LOCALVERSION. A sparse source
cache must materialize the complete source in the fresh worktree first.
Do not copy this7.3 module into a6.12 kernel. No installation, boot-media update
or firmware payload is part of the export. Preserve Linux and per-file notices.
The board patches retain their upstream/vendor attribution.

No glibc update was required for this freestanding build. The project's patched
Trixie glibc2.41 runtime validation and modern SPE userspace compiler restoration
are separate SDK tasks; ordinary PowerPC GCC14 kernel compilation does not
establish a modern SPE userspace ABI.

## Subsequent QEMU gate

A separate QEMU configuration of this clean source boots a single e500v2 CPU
and reaches a shell. Eight of nine existing SPE ABI checks pass (fenv still
fails); software/SPE fractal images match. With two CPUs, startup stalls before
userspace; a temporary nosmap control also stalls. These are QEMU10.0.13 results,
not physical Radeon acceptance. The old rescue root is not a complete Trixie
installation or a GCC14-built SPE userspace.

A matching hardware update bundle is staged inactive on the user's live A1222.
The working kernel, early firmware and boot.scr are unchanged; no reboot was
performed while this startup gate remains unresolved. Evidence is retained in
canonical commit54a5abd. Fresh modern SPE compiler/libgcc/libc qualification is
the next foundation task before rebuilding the workstation archive.
