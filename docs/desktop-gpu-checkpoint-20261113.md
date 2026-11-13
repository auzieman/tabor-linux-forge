# Desktop and GPU checkpoint — 2026-11-13

Authoritative toolchain commit: `1ca2418fbc36f9844527958ef0297ab7a03de11a` ([source](https://github.com/auzieman/amigaos-toolchain_patch/tree/1ca2418fbc36f9844527958ef0297ab7a03de11a)). Forge consumes this reviewed checkpoint; it does not fork compiler/kernel/driver work.

The [toolchain handoff](https://github.com/auzieman/amigaos-toolchain_patch/blob/1ca2418fbc36f9844527958ef0297ab7a03de11a/docs/gpu-desktop-handoff-20261113.md) pins incremental patches and regression evidence. Polaris11 on A1222 passes clear/uniform RGB probes and a visible rotating cube at60.113460FPS with `AMD_DEBUG=vs,ps`. Heavy VM checks are unnecessary for this run. Normal mode is still grey; this is a diagnostic graphics candidate, not a release-ready acceleration stack. X11/Enlightenment and complex models remain untested. Existing standalone demo dependencies are not a qualified GCC14 desktop package set.

No build containers were active at inspection. The boot-media pipeline stopped with an infrastructure failure after17 and60 successful stage build records;2 source records failed. The retry stopped at its infrastructure-review guard. Retained fallout includes GCC internal compiler errors in db5.3/systemd and Python/GIR dependency gaps. These are historical failed inputs until compared with the current patched SDK; do not assume they require new source patches. No complete base installation was accepted.

Continue through the [base image](debian-base-image.md): reconcile controller failure and GCC14/root identities, retain accepted caches/artifacts, rebuild dependency-ready producers through standard sbuild, assemble shell/dpkg/apt/SSH with apt, then install software X11/E. Preserve the known console and rollback independently. GPU optimisation can continue without blocking the base.

The GCC14 SDK/runtime packages, clean root and normal zlib qualification have recorded build evidence in the authoritative project; this does not make `qualified_sdk_export` non-null or qualify an installed image. Review and pin the intended SDK export separately.

Themes and selected applications follow the [AlpinE intake](alpine-desktop-port.md); Enaptic uses [APT/dpkg integration](enaptic-apt-port.md), with no APK or Flatpak payload installation. Partition resizing and installers remain later independent work.
