# AVEVA E3D Custom PMLLIB

Custom PML helpers for AVEVA E3D / PDMS-style PML automation.

This repository is not affiliated with, endorsed by, or supported by AVEVA.
It contains only user-authored PML files and examples. Do not commit AVEVA
standard PMLLIB files, binaries, project databases, or licensed content.

## Contents

```text
pmllib/
  mylib/
    design/
      copyfunc/
        copyce.pmlobj
        copycepostevents.pmlobj
        copyCe*.pmlfnc
docs/
  install.md
  copyce.md
examples/
  copyce-test.pmlmac
scripts/
  install-local.ps1
```

## Quick Start

Install into a local E3D PMLLIB:

```powershell
.\scripts\install-local.ps1 -E3DVersion "Everything3D2.10"
```

Then in E3D, run on a safe test element:

```pml
!created = !!copyCeTestCurrent()
```

Single copy:

```pml
!copy = object COPYCE(!!ce, !!ce.owner, 'copyof', 'Copy CE', 'DEFAULT')
!newCopy = !copy.run()
```

## Naming Modes

```text
DEFAULT     /copyof-OriginalName
TYPEPREFIX  /typecopy-PIPE-OriginalName
PIPEBRANCH  /pbcopy-P-OriginalName or /pbcopy-B-OriginalName
LOWER       /lowercopy-originalname
```

See [docs/copyce.md](docs/copyce.md) for object methods, wrappers, and a flow diagram.

## Safety

- Test in a disposable project or writable sandbox first.
- Each copy operation creates a `MARKDB` undo mark.
- Use `UNDODB` or `UNDODB n` to revert test runs.
- Review naming rules in `copyce.pmlobj` before production use.

## License

MIT. See [LICENSE](LICENSE).
