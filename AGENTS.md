# Tabor Linux Forge

Read README.md, docs/trixie-spe-baseline.md and
.agents/skills/tabor-port-pipeline/SKILL.md for distribution work.

This repository consumes reviewed exports from amigaos-toolchain_patch, the
source of truth for compiler/runtime/kernel/driver development. Keep exact
source, patch, configuration and artifact hashes with each export. Do not
silently fork the toolchain or describe an unpinned reference as reproducible.

The distribution target is Trixie powerpcspe using GCC14, not the GCC8 bootstrap.
Preserve historical artifacts and vendor notices. Keep source preparation,
compilation, target execution and physical hardware acceptance distinct.

Use standard Debian package/build mechanisms. Run heavy work on the build
server, not the laptop. Default to a small diagnostic or representative build;
only widen an explicitly selected, dependency-ready batch after qualification.
Preserve caches and completed artifacts. No automatic publication or push.

Include .agents/skills and .agents/prompts in reviewed GitHub exports. Exclude
credentials, machine-local configuration, logs, SDK binaries and private paths.
