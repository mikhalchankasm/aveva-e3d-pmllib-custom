# Install

## Option 1: Copy with script

From the repository root:

```powershell
.\scripts\install-local.ps1 -E3DVersion "Everything3D2.10"
```

Default target:

```text
C:\Program Files (x86)\AVEVA\Everything3D2.10\PMLLIB
```

Custom target:

```powershell
.\scripts\install-local.ps1 -PmlLibRoot "D:\AVEVA\PMLLIB"
```

The script copies `pmllib\mylib` into the target PMLLIB root.

## Option 2: Manual copy

Copy:

```text
pmllib\mylib
```

To:

```text
C:\Program Files (x86)\AVEVA\Everything3D2.10\PMLLIB\mylib
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
