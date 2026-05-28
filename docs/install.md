# Install

## Option 1: Copy with script

From the repository root:

```powershell
.\scripts\install-local.ps1 -E3DVersion "Everything3D2.10"
```

Default target:

```text
C:\Program Files (x86)\AVEVA\Everything3D2.10\PMLLIB\e3dctools
```

Custom target:

```powershell
.\scripts\install-local.ps1 -PmlLibRoot "D:\AVEVA\PMLLIB"
```

Custom PMLLIB folder name:

```powershell
.\scripts\install-local.ps1 -PmlLibRoot "D:\AVEVA\PMLLIB" -LibraryName "mycompanytools"
```

Legacy local sandbox example:

```powershell
.\scripts\install-local.ps1 -E3DVersion "Everything3D2.10" -LibraryName "mylib"
```

The script copies `pmllib\e3dctools` into the selected folder under the target PMLLIB root.

`mylib` is intentionally not used as the public default because many users already have local test folders with that name. This repository uses `e3dctools` as its product-style PMLLIB folder.

## Option 2: Manual copy

Copy:

```text
pmllib\e3dctools
```

To:

```text
C:\Program Files (x86)\AVEVA\Everything3D2.10\PMLLIB\e3dctools
```

## Verify

In E3D, select a safe test element and run:

```pml
!created = !!copyCeTestCurrent()
```

If something is wrong, use:

```pml
UNDODB 4
```

The test creates four copy operations, each with its own `MARKDB`.
