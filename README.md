# AVEVA E3D Custom PMLLIB

Public repository for user-authored PML helpers, objects, wrappers, examples, and notes for AVEVA E3D / PDMS-style automation.

The goal is to keep reusable custom functions in one predictable structure so they can be installed into a local `PMLLIB`, reviewed, tested, and reused across projects. This repository is expected to grow: each function or feature should live in its own folder with its own short documentation and examples.

This repository is not affiliated with, endorsed by, or supported by AVEVA. It contains only user-authored PML files and examples. Do not commit AVEVA standard PMLLIB files, binaries, project databases, or licensed content.

## Repository Layout

```text
pmllib/
  mylib/
    design/
      <module>/
        *.pmlobj
        *.pmlfnc
        README.md
docs/
  install.md
examples/
  *.pmlmac
scripts/
  install-local.ps1
```

## Install

Install the repository `pmllib` content into a local E3D PMLLIB path:

```powershell
.\scripts\install-local.ps1 -E3DVersion "Everything3D2.10"
```

See [docs/install.md](docs/install.md) for installation notes.

## Function Catalog

### COPYCE

Human-controlled database element copy helper. It creates a copy, applies configurable naming rules, keeps copied names within the E3D name-length limit, and creates a `MARKDB` undo mark.

Files:

```text
pmllib/mylib/design/copyfunc/
```

Documentation:

- [Russian README](pmllib/mylib/design/copyfunc/README.md)
- [English README](pmllib/mylib/design/copyfunc/README.en.md)
- [Technical notes](docs/copyce.md)

Quick example:

```pml
!newCopy = !!copyCeWithCopyofNames(!!ce, !!ce.owner)
```

## Adding New Functions

For each new helper, prefer this pattern:

- Put the implementation under `pmllib/mylib/design/<module>/`.
- Add a local `README.md` near the PML files.
- Add a small safe example under `examples/` when possible.
- Document expected inputs, outputs, side effects, and undo behavior.
- Keep generated names, database writes, and project-specific assumptions explicit.

## Safety

- Test in a disposable project or writable sandbox first.
- Review database write operations before using a helper in production.
- Prefer helpers that create a `MARKDB` undo mark for destructive or bulk actions.
- Use `UNDODB` or `UNDODB n` to revert test runs where supported.
- Avoid committing project databases, generated binaries, licensed AVEVA files, or customer data.

## License

MIT. See [LICENSE](LICENSE).
