# Release policy

Releases are produced from the generated `patched` branch after the patchset applies cleanly on top of upstream `master`.

Version format:

```text
v<upstream-package-version>-patch.<N>
```

Examples:

```text
v12.0.17-patch.1
v12.0.17-patch.2
v12.0.18-patch.1
```

Release notes are generated from patch metadata only. Do not include upstream issue or pull request references.
