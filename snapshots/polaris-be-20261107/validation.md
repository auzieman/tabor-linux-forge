# Physical A1222 checkpoint — 2026-11-07

Hardware: A1222/Tabor, PPC32 big-endian e500v2/SPE, Radeon RX 560
(Baffin/Polaris11, PCI 1002:67ff). Exact tested module and configuration hashes
are in manifest.json. The module was compiled successfully; the retained
configuration and Module.symvers matched the accepted reference.

Verified during the latest first-bind experiment:

- Earlier boot milestones include physical kernel boot, networking, SSH and
  selected SPE instruction/ABI probes. These do not establish a full workstation.
- Cold SMU firmware loading and pre-map GFX/KIQ scratch gates passed.
- GPU readback matched the immediate test and 22 sampled MQD fields.
- SET_RESOURCES followed by the KIQ scratch test passed.
- All eight MAP_QUEUES submissions, each followed by the KIQ test, passed.
- The final all-queue-submissions marker was reached.

**Unresolved:** later initialization produced a PCIe error storm and SSH stopped
responding. A purple/magenta display was reported, not a readable framebuffer.
The root filesystem had been remounted read-only before the trial. A failed SSH
connection alone cannot prove the whole CPU is dead; the retained PCIe storm and
lost access make this an unsuccessful hardware validation.

Splitting submissions with diagnostic gates changes timing. Passing KIQ gates
does not establish that all mapped compute queues execute correctly. The next
bounded test should mark ordinary post-map ring tests and identify the first
failing stage before adding more conversions or bypasses. Accelerated Mesa,
Xorg/E, sustained GPU use, complete RAM/SMP acceptance and the complete modern
SPE userspace remain separate validation gates.

Detailed private lab evidence is retained with canonical commit 729e3b1.
Only this sanitized summary is exported; no lab credentials or raw ROM dumps.
