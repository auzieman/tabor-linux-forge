# Reverse Engineering Notes

## Debian Image Findings

Reference image inspected:

- `Tabor_debian_8_powerpcspe_5.7z`

Mounted root filesystem path during inspection:

- `/media/auzieman/69666bb4-a548-4317-b6ac-fcb95aac4fc6`

### Root Filesystem

The mounted rootfs appears to be a real Debian 8 `powerpcspe` system, not a
tiny custom rescue image.

Observed:

- `/etc/debian_version` reports `8.0`
- `/etc/fstab` mounts `/dev/sdb2` as `/`
- `/etc/network/interfaces` uses normal DHCP config on `eth1` and `eth2`
- hostname is `TaborPowerPCSPE`
- `powerpcspe` appears throughout package metadata and docs
- `/lib/modules/3.18.24-Tabor-JM` exists

This strongly suggests:

- userspace is relatively normal Debian `powerpcspe`
- the boot path is the unusual part
- we should avoid overcomplicating the future rootfs before boot mechanics are solved

### Boot Artifacts

Observed from extracted boot files:

- `tabor2.dtb` is a normal DTB, about 14 KiB
- `uImage.sdk17.2` is not a plain legacy U-Boot image at byte 0
- `binwalk` found a valid embedded U-Boot image header at offset `0x440200`
- embedded image name: `Linux-3.18.24-Tabor-JM`
- embedded image type: Linux / PowerPC / gzip / legacy `uImage`
- embedded load address: `0x00000000`
- embedded entry point: `0x00000000`

This implies the shipped file is a wrapped blob containing a standard legacy
U-Boot image at a nonzero offset, not a raw `uImage` as generic Linux tooling
would emit.

### Firmware / U-Boot Clues

Observed from the board firmware environment:

- a built-in Linux boot path exists
- environment includes conservative memory limit `mem=3500M`
- `console=ttyS0` appears in the boot args
- a live boot path references `/dev/ramdisk` and `boot=casper`
- `fdtaddr` is set in firmware

This suggests the firmware has board-specific expectations that should be
treated as the source of truth during bring-up.

## Working Assumptions

1. The root filesystem can remain relatively conventional.
2. The boot image wrapper is likely the main compatibility obstacle.
3. Gentoo should remain a later userspace/rootfs track, not the immediate
   answer to boot failures.
4. Near-term work should focus on reproducing the shipped image's boot wrapper
   characteristics and firmware expectations before replacing the rootfs.

## Open Questions

1. What occupies the bytes before the embedded `uImage` header at `0x440200`?
2. Does the firmware `Boot Linux` path search for that wrapped file shape
   specifically?
3. Is the shipped `uImage.sdk17.2` loaded by a board helper before the legacy
   U-Boot header is reached?
4. Does the original image contain a separate boot partition copy of these
   artifacts that we have not yet mounted?
