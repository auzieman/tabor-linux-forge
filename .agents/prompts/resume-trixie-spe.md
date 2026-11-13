Use the tabor-port-pipeline skill. Resume the GCC14-based Trixie powerpcspe
baseline from docs/trixie-spe-baseline.md. Inspect actual active jobs and the
latest receipts before compiling. Keep work measured: one demonstrated blocker,
a focused regression and representative normal sbuild validation before widening.

Do not use GCC8 as a fallback or count its prior artifacts as final output.
Compiler/runtime fixes belong in the authoritative toolchain project, then enter
Forge as pinned exports. Current checkpoint: GCC14 SPE thunk fix passes C++
build/link/QEMU probes; directed-rounding emulator control and SDK/root migration
remain open. Do not claim the larger package loop has resumed without evidence.

Near-term output: the apt/dpkg-installed base in profiles/debian-base-image.json,
validated as a bootable shell/network/SSH system before adding software X/E.
Do not wait for every desktop development package or accelerated graphics.

Read docs/desktop-gpu-checkpoint-20261113.md for the pinned GPU source commit and actual desktop build pulse. No active queue or installed-image acceptance is implied by package counts.
