# Trixie / GCC14 development baseline

The goal is a new Tabor Linux Forge distribution for A1222/P1022 e500v2,
using GCC14 throughout target runtimes and compiled packages. GCC8 was an earlier
bootstrap; its accumulated packages do not satisfy this distribution milestone.
The machine-readable target is [the baseline profile](../profiles/trixie-spe-baseline.json).

The authoritative compiler/runtime/kernel/driver development project remains
[amigaos-toolchain_patch](https://github.com/auzieman/amigaos-toolchain_patch).
Forge consumes the reviewed pieces needed to reproduce the distribution. The
[source checkpoint](https://github.com/auzieman/amigaos-toolchain_patch/commit/b5d56fc166e0c9a7aec299c74fd739c05f174f54)
is pinned in the baseline profile. A qualified GCC14 SDK export is still absent;
this is a development checkpoint, not a reproducible release claim.

## Verified checkpoint — 2026-11-12

The restored SPE GCC backend retained an obsolete thunk-emission convention.
Patch0018 adds function entry/exit assembly matching the GCC14 target-hook model.
An isolated compiler/full libstdc++ rebuild passes; previously missing destructor
thunks are defined, C++ linking succeeds, and e500v2 QEMU checks pass long-double128,
exception unwinding, thread/TLS and atomics.

C ABI checks pass float32/64, varargs, formatting, setjmp, signals, pthread/TLS
and ucontext. Directed floating-point rounding still fails under the tested
QEMU. Upstream QEMU10.0.13 source exposes a separate SPE register/status update
path consistent with that symptom; a corrected-emulator or hardware control is
still needed. No expected result was weakened. Detailed evidence and patch hashes
remain in the authoritative project's gcc14-sdk-20261108 records.

The GCC8 package queue is stopped. The larger GCC14 package loop has not restarted.
Next gates are rounding validation, genuine SDK/runtime Debian packages, clean
build-root migration and representative sbuild qualification. Final artifact reuse
must identify the exact qualified GCC14 SDK, not merely a matching package version.

Existing physical console evidence remains in the preserved kernel snapshots.
It is distinct from the unassembled GCC14 workstation and does not imply working
3D acceleration or a completed live image.

## Repeatable, measured continuation

Use the [port skill](../.agents/skills/tabor-port-pipeline/SKILL.md),
[resume prompt](../.agents/prompts/resume-trixie-spe.md) and
[export review prompt](../.agents/prompts/review-build-export.md).
Fix the earliest shared blocker, qualify a small representative set, then build
the selected closure with normal Debian dependency handling. Preserve caches,
source locks and prior results; do not repeat successful work without cause.

Assemble shell/apt/SSH through real apt/dpkg installation before software X/E.
Treat compilation, installed-system checks, QEMU and board tests as separate gates.
Future updates must pin a new baseline and repeat those checks explicitly.

## GitHub export contents

Include the relevant `.agents/skills/` and `.agents/prompts/` alongside source
patches, configuration, provenance and build instructions. Keep credentials,
local account/network configuration, bulk logs and SDK binaries out. Pin exported
commits/hashes before claiming reproducibility. Publication remains a separate,
explicitly requested action.
