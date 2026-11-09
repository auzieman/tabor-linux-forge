# A1222 Polaris11 candidate007: visible console

This pinned Linux6.12.113-1 / GCC14.2.0 experiment reaches a **readable local
console on the physical A1222 with Radeon1002:67ff**. The user confirmed the
screen; Linux reports1920x1080 HDMI,32bpp `amdgpudrmfb` and bound fbcon. Normal
installed `modprobe amdgpu` returned0 and SSH survived with kernel taint0.

This is a rescue-console milestone. The GFX indirect-buffer test still times
out-110. Accelerated rendering, Xorg/E and games remain unvalidated. Do not
promote this diagnostic snapshot as a complete working GPU driver or desktop.
See [physical results](hardware-summary.json).

The canonical development source remains
[amigaos-toolchain_patch](https://github.com/auzieman/amigaos-toolchain_patch).
This export carries only27 ordered kernel patches, the exact configuration,
build/validation metadata and boot-script source for contributor review. It
contains no SDK, firmware binaries, private keys, account data or USB image.
Contributions can be proposed here for review and canonical integration.
Its manifest pins the canonical code commit and all input hashes.

## Reproduce source and kernel

Use the source archive files and SHA256 values in `manifest.json`, preserving
the cache rather than downloading unchanged inputs on each run. With the pinned
PowerPC GCC14.2.0/binutils2.44 tooling:

```sh
python3 tools/build-kernel-snapshot.py \
  --snapshot snapshots/polaris-be-20261108-e2e007 \
  --source-cache /path/to/verified-debian-source-cache \
  --work /path/to/new-build-directory --jobs 4
```

Run this on a build server with4CPUs/6GiB limits; do not compile on the laptop.
The tool uses `dpkg-source`, ordered checked patches and ordinary Kbuild.
`--prepare-only` stops after extraction, patch application and exact config
qualification. Fresh preparation passed on the R730 with1CPU/3GiB and no network.
**All20 files touched by the27 patches match the compiled007 source byte-for-byte**,
and `olddefconfig` reproduces its exact configuration hash. See
`source-comparison.json` and `prepare-receipt.json`. The complete007 build was
qualified separately; artifact/compiler hashes and687 matching imported module
CRCs are recorded in `build-qualification.json`. A second full build was not run
solely for publication. Build paths/debug info can affect binary hashes.

Use normal `modules_install` and `depmod` to package this exact kernel's modules;
never insert its module into an older kernel. Generate a PPC legacy gzip uImage
from `objcopy -O binary vmlinux`, with load/entry0, retaining the matching
`tabor-a1222.dtb`. Supply the external Polaris11 firmware matching the recorded
hashes. `boot-e2e007.cmd` documents the tested load addresses, existing small
firmware initrd and ext4 disk-root layout. Its PARTUUID and paths describe the
lab medium; identify other media before adapting it. This export does not
repartition, flash or install a USB drive.

## What changed and what passed

The last003 hardware trial passed UVD decoder and both encoder primary ring
tests, then lost SSH during SCLK-mask command0x145 with parameter0x80. Review
found six raw V1 state-clock loads missing little-endian decoding; connected
tests reproduce downstream clock/table/mask corruption. Candidate007 adds that
boundary correction, SMU/PSM transition-error propagation, and propagation of
DCE11 surface-programming errors. On007 the SCLK command carries0xff and
receives response1; several changes were tested together, so individual causal
effects are not isolated.

Nineteen offline source/byte-contract suites pass, including the actual ATOM
interpreter, connected display producers, Linux font rendering/TTM/DCE11 path,
state-clock/table/mask flow and recorded x86 SMU replay. Negative controls detect
missing conversion on PPC while preserving x86 behavior. These are software
tests with modeled device endpoints, not a complete GPU simulator. The earlier
aggregate offline gate remains BLOCKED for full hardware coverage; the newly
accepted physical console is a separately recorded gate.

The protected physical test used fresh boot, exact module hash, verified
read-only root and off-board kmsg before one normal load. The first preparation
attempt stopped before loading because sshd logged to the USB root. Runtime
logging was moved into RAM and the listener reopened before the successful
protected attempt. No post-fault unload/reload was used. Native rescue `/init`
provides a bootstrap shell; a full Debian getty/desktop is a later deliverable.

The remaining GFX IB timeout and later engine workloads need their own review
and bounded validation. No global PCIe byte-swap or x86 CPU emulation is
introduced. ATOM parameters, native workspaces, SMU tables, GPU rings/IBs,
writeback and framebuffer pixels retain their separate protocol contracts.

## Confirmed framebuffer fractal follow-up

The user also confirms a correct coloured Mandelbrot image on physical HDMI.
The existing CPU benchmark generated identical12,288 escape counts using
software floating point and explicit SPE instructions. Median render times
were125574us and23846us respectively for the128x96/96-iteration workload,
excluding presentation. This5.266 ratio applies to that test only.

A separately checked integer-only fbdev presenter enlarged the verified image
8x to1024x768 over the terminal, preserved the covered pixels in RAM and passed
complete framebuffer readback. No GPU mode change, rebind or3D API was used.
Source and raw results remain canonical in
[62cb62c](https://github.com/auzieman/amigaos-toolchain_patch/commit/62cb62c).
Console and CPU/SPE visual-demo acceptance now pass; GFX IB/accelerated GL
remain open in [forge issue1](https://github.com/auzieman/tabor-linux-forge/issues/1).
