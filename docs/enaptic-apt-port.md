# Enaptic for Tabor: APT/dpkg only

User-selected scope: reuse Enaptic's native Elementary interface, search,
package details, queued marks and reviewed Apply for Trixie/powerpcspe. Build
against the Debian EFL baseline. No Flatpak support or dependency is required;
the Tabor build should omit its provider controls and code paths. Preserve the
existing AlpinE APK/Flatpak implementation in the source project.

The existing transaction bridge is implemented against libapk. This is an
actual backend replacement, not a command-name substitution. Keep the shared
UI/backend capability boundary and adapt APK-specific status text and world
selection semantics to Debian installed/automatic/held package state.

- Use APT/libapt-pkg (evaluate python3-apt against the actual SPE package set)
  for catalog queries, Debian version ordering and dependency resolution.
- Use native dpkg/APT installed, candidate, architecture and origin identities;
  distinguish explicitly installed packages from automatic dependencies.
- Retain queued install/remove/upgrade marks and one complete native transaction
  preview, including solver-added changes and download/space information.
- Apply through a narrow authenticated helper. Revalidate the reviewed package
  and source state using APT's actual lock/transaction semantics; the existing
  APK lock/commit implementation cannot serve as proof for the APT adapter.
- Keep repository signatures, downloads, maintainer scripts, triggers, conffiles
  and database writes with APT/dpkg. Do not parse human terminal output as a
  replacement dependency solver or run a loop of individual package commands.
- Support the target's configured sources, including Debian deb822 sources and
  its signed SPE archive. Do not import Alpine sources, keys or service commands.

Validate catalog/preview first in the disposable Tabor QEMU install. Then test
install, upgrade, removal and stale-plan rejection using disposable packages and
normal Debian state. Build success, target execution and authenticated Apply are
separate checks. This document stages the port; no APT backend is implemented
or qualified yet, and no package/source configuration has been changed.
