# A1222 contributor handoff — 8 November 2026

The canonical toolchain project owns compiler, libc and driver patches. This public note records findings and a small reproducible audit; it does not replace the existing pinned build snapshot or publish a new working GPU image.

## Current acceptance

- Physical A1222 Linux boots with SPE support, networking and SSH.
- A GCC14 candidate with the SPE reload correction passed all nine checks in the original C ABI probe using a separately invoked fresh glibc2.41 runtime on real hardware. Broader compiler/runtime regression and Debian package acceptance remain open. QEMU rounding differs from hardware; do not treat that as a reason to weaken libc semantics.
- RX560/Baffin (1002:67ff) under 6.12.113-tabor-modular passes GFX/KIQ/compute/SDMA scratch checks. These are not indirect-buffer, full rendering or scanout acceptance.
- A protected first-bind candidate fails following SMU DPM_Enable (0x14e): a PCIe fault appears approximately45ms later, initialization fails and SSH becomes unavailable. No local login console or accelerated desktop is accepted. Off-board capture and read-only USB root preserved the negative result.

## Useful source findings

The newer SMU7 display-voltage dependency implementation is already present. A separate startup error-propagation experiment prevents continuing after mandatory failures; its native function tests pass, but it is not hardware-qualified and is not a demonstrated bus repair.

The AVFS calibration audit reproduced a specific BE serialization defect: pre-swapped native integer literals are copied directly as bytes. The SMC byte uploader preserves them, so x86 frequency bytes00007530 (30000) become30750000 on BE PPC. ActivityLevel and VRConfig show the same class of discrepancy. See audit.json for exact source hashes and sample results. audit.py is read-only and expects the explicit R730 source path; adapt the path to an identical hashed checkout before reproducing elsewhere.

**Causality remains open.** Calibration requires the hardware AVFS efuse bit, PP_AVFS_MASK and a cold firmware-start path. The existing logs do not record enough to prove that this board executed it. The audit models three field byte layouts; it is not a complete cross-compiled structure test. No AVFS correction or new GPU binary is exported here.

## Contributor focus

Review polaris10_setup_graphics_level_structure and both static AVFS level structures against smu7_copy_bytes_to_smc. Correct every multi-byte field at the producer, preserving byte fields and the known x86 payload. Do not globally swap MMIO or the common uploader. Compare complete x86 and BE compiled objects, retain mandatory-error propagation separately, and record the AVFS gate before another bounded cold first-bind.

The first hardware goal is no PCIe fault, surviving SSH and readable fbcon/DRM scanout. X/E, acceleration and a workstation image follow independently. Historical Tabor desktop reports used older Radeon configurations; the vendor5.4 config enabled radeon and disabled amdgpu, so they do not establish RX560 acceptance.

Derfsss U-Boot, QEMU and MCP material is useful reference. The reviewed QEMU AmigaOne/G5 branch is not an A1222/P1022 SPE hardware substitute. No contributor fix is claimed until submitted and reviewed; no firmware has been flashed by this review.

Canonical evidence and patch work: [toolchain status](https://github.com/auzieman/amigaos-toolchain_patch/blob/4a5876dcf829f245724fb293e617de067df51436/docs/status-20261108.md) (private repository; access required). The source of truth remains there. Contributors without access can discuss or submit source patches on this forge branch.
