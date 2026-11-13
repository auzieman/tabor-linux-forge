Use the tabor-port-pipeline skill. Review a proposed build export against the
recorded Forge baseline. Check exact upstream versions, toolchain commit and
patch hashes, compiler/runtime provenance, Debian bootstrap profiles and omitted
outputs. Distinguish source/build, target runtime and physical hardware evidence.

Include the relevant .agents/skills and .agents/prompts in the reviewed export.
Keep unrelated toolchain development, SDK binaries, credentials and machine-local
configuration out. Report missing pins/gates plainly. Do not publish or push
unless requested by the user.
