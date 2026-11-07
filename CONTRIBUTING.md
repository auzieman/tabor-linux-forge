# Contribution workflow

The toolchain project is the authoritative development source. Forge snapshots
are versioned consumers, not a separately maintained SDK or driver fork.
Propose changes on work branches; retain exact base commit, patch ordering,
configuration, compiler identity and artifact hashes with each validation.
Reconcile accepted driver/toolchain fixes into the canonical project before
issuing a replacement export. Contributors without private-project access can
submit source-level patches here for review and canonical integration.

Use `wip/polaris-be` for the current experiment. Record build, emulator and
physical-hardware outcomes separately in commit-linked validation notes; do not
maintain drifting copies on separate build/test branches. Include failing stages
and negative results. Do not import private SDKs, account information, firmware
or media images. Preserve source licenses. No contributor patches are implied
until actually submitted and reviewed.
