# First deliverable: an installed Debian base image

Build a Trixie powerpcspe filesystem that subsequent X11, Enlightenment and
utility packages can install into through apt. This is the near-term AUZiX
netimage-style goal. A kernel-only image or an unpacked demo bundle is not it.
The [base profile](../profiles/debian-base-image.json) selects the package seeds;
Debian apt resolves their runtime Depends and Pre-Depends. Do not turn the full
workstation build-dependency inventory into the base installation manifest.

The selected seeds' names were checked against the retained frozen Debian
binary metadata. That establishes valid names and source producers, not that
SPE builds or installation are ready. Let the signed target archive choose
its reviewed versions; never install amd64/ppc64el libraries into this root.

## Build and assembly sequence

1. Qualify and package the GCC14 SPE SDK and target runtimes. Register them in
   clean Debian build roots. Reject GCC8/unknown compiler identity as final output.
2. Prioritize the sources producing Essential/minbase and the profile's selected
   binaries. Derive additional producers from Debian metadata when actually
   missing. Preserve accepted source/cache work and supported bootstrap profiles.
3. Publish verified target packages into the signed archive's main component.
   Keep build-root-only bootstrap providers out of the final installation pool.
4. Use mmdebstrap's normal minbase variant for powerpcspe, including the profile's
   seeds. Execute target configuration through a qualified e500v2 QEMU environment
   on the build server. Keep maintainer scripts and triggers enabled. Do not use
   fake dpkg state, --force-depends, unsigned repositories or raw .so copying.
5. First assemble a fresh directory/file image on the server. Validate package
   state and boot under QEMU before writing a new physical boot candidate.
   Retain the known-working board kernel/DTB/boot-script rollback separately.
6. Verify the acceptance checks listed in the profile. Generate fresh per-install
   SSH host keys; never embed the builder's keys or private account configuration.

Networking starts with ifupdown/iproute2/dhcpcd-base; systemd supplies init and
udev supplies device setup. Keep interface configuration independent of fixed
lab addresses. Console access must remain usable if networking fails.

## Current prerequisite and boundary

GCC14's C++ thunk failure is fixed and its C++ probe passes. Directed rounding
still needs its corrected-emulator/hardware control; SDK/runtime packaging and
clean-root migration remain pending. The package loop has not resumed and this
base has not been assembled. See [the baseline](trixie-spe-baseline.md).

Once the base passes, install software X11 and Enlightenment as another package
layer. Retain 3D work for later community patch integration. Installers and
AmigaOS partition detection/resizing are later work and require separate
filesystem/hardware validation; no partition writes are part of base assembly.


2026-11-13 update: [desktop/GPU checkpoint](desktop-gpu-checkpoint-20261113.md) supersedes earlier pending/running status where noted. The build queue is idle/infrastructure-failed; the60FPS diagnostic cube does not establish installed desktop acceptance.
