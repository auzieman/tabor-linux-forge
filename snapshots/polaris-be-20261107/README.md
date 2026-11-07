# Polaris BE experimental kernel snapshot — 2026-11-07

This is a build-only export from canonical toolchain commit
`729e3b185a803e1f54953208fa209701c532ee9b`.
The authoritative SDK and driver development stays in
[amigaos-toolchain_patch](https://github.com/auzieman/amigaos-toolchain_patch)
(private access required). Do not independently maintain a second SDK here.

This experiment pins Debian Linux **6.12.113-1**, GCC **14.2.0** and
Debian binutils **2.44**. It is separate from the broader Debian package-port
baseline. The manifest records ordered patch hashes, source hashes, exact
configuration and the tested module hash. The build image digest records the
local lab environment; it is not a publicly pullable image reference.

Cache the three source files from their manifest URLs once. Use an existing
qualified build environment containing dpkg-source, git, make, the PowerPC cross
compiler/binutils and normal kernel build prerequisites (bc, bison, flex,
libssl-dev, libelf-dev, python3). Mount the shared toolchain read-only; keep
source and output disposable. No SDK clone per job is required.

```sh
python3 tools/build-kernel-snapshot.py --source-cache /cache/linux --work /work/new-run --prepare-only
# For a complete build, select a different fresh work directory and omit --prepare-only.
```

Run inside a constrained server build container (normally 4 CPUs / 6 GiB),
with cached inputs mounted read-only and no network needed. The script verifies
all inputs, extracts with dpkg-source, applies each patch without fuzz, checks
the resulting configuration and invokes standard Kbuild. It refuses to reuse a
work directory. It does not install modules, write USB media or reboot a board.
A custom read-only SDK prefix can be supplied with --cross-compile.

The retained series compiled before export. The public entrypoint's fresh
preparation check is a separate gate. Compilation does not establish working
graphics, a complete Debian installation or a full modern SPE userspace ABI.
See [hardware validation](validation.md). Kernel patches retain upstream Linux
licensing and notices; no firmware binaries, proprietary SDK material or ROMs
are included.
