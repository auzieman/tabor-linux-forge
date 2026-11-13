# AlpinE desktop intake for Tabor

The local AlpinE recipes match the frozen Tabor Debian core versions:
EFL 1.28.1, Enlightenment 0.27.1 and Terminology 1.14.0. No core upgrade is
needed merely to match AlpinE. The additive applications, utilities and artwork
are the useful intake. [Candidate inventory](../profiles/alpine-desktop-port.json)
records the AlpinE commit plus actual working-recipe hashes; this accounts for
uncommitted recipe content without pretending the commit alone pins it.
Nothing in this inventory has yet been imported, built or installed for SPE.

| Candidate | Port approach |
| --- | --- |
| Ecrire 0.2.0, Ephoto 1.6.0, Evisum 2.0.12 | Prefer existing Debian source packaging; adapt retained sources/patches when needed. |
| E-Jamz 0.1.0 | Source rebuild with GCC14/SPE; recipe currently selects x86_64 and invokes native `cc`. Separate host font/Edje generators from target compilation. |
| E-control | Rebuild native EFL UI; review Debian service, authentication and device providers. |
| AlpinE and BlackKnight wallpapers | Package assets/source-built EDJs as Debian data packages, retaining component notices. |
| Retained 23-theme collection | Preserve individual provenance and notices; check E/Elementary compatibility and target rendering before choosing defaults. |
| E'ifyd | Reuse UI ideas later; Alpine apk/OpenRC/GRUB and storage actions are not a Tabor installer backend. |
| Assigns and other utilities | Inventory optional scripts/native pieces; keep Debian paths and package ownership. |

Do not convert or install native Alpine APK payloads into the Debian target.
Use the APKBUILD as recipe/provenance input, then produce normal Debian packages
against the frozen Trixie/SPE foundation. A newer application version is an
explicit source backport; it must not advance the system-library baseline.
Keep the existing large dependency build running while staging this additive
intake; do not replace its package selection or rebuild the compiler for it.

The near-term graphics target is X11 plus Enlightenment with software rendering.
Software OpenGL is a later session check; it does not require accepted AMDGPU
hardware acceleration. A successful package build is distinct from an installed
QEMU desktop and from physical PNY/A1222 acceptance. The normal apt/dpkg base,
SSH recovery and working 2D scanout remain prerequisites for the physical trial.
Retain the SanDisk recovery media.

Themes and scripts are candidates for direct data packaging, but an APK's
`noarch` declaration is not target runtime evidence. Match native Edje tooling
to the target EFL format, rebuild from source where appropriate and check the
result in the target session. Defaults should preserve existing user settings.

Selected scope is themes/wallpapers and our applications (E-control, E-Jamz,
Enaptic); Ecrire/Ephoto/Evisum are optional rather than immediate imports.
[Enaptic’s Tabor backend is APT/dpkg only](enaptic-apt-port.md), with no Flatpak
provider or Alpine transaction bridge in that build.
