# AvevaE3D.CustomTools

All-in-one custom PMLNet tools assembly for this repository.

The first module is `AvevaE3D.CustomTools.Copy.CopyTools`. It mirrors the COPYCE naming rules in C# so the complex parts can be developed and tested outside PML before moving more of the copy workflow into .NET.

## Target

- AVEVA E3D 2.10 local samples use .NET Framework 4.0 projects.
- Platform target is `x86`.
- `PMLNet.dll` is referenced from `$(E3DInstallDir)`.

Default `E3DInstallDir`:

```text
C:\Program Files (x86)\AVEVA\Everything3D2.10
```

Override it during build if needed:

```powershell
dotnet msbuild src\dotnet\AvevaE3D.CustomTools.sln /p:E3DInstallDir="C:\Program Files (x86)\AVEVA\Everything3D2.10" /p:Configuration=Release /p:Platform=x86
```

## Release Package

GitHub-hosted runners do not have AVEVA `PMLNet.dll`, so this DLL is built locally or on a private self-hosted runner with E3D installed.

Create a local zip package:

```powershell
.\scripts\publish-dotnet-release.ps1 -Version "0.1.0"
```

Create the package and upload it to GitHub Releases:

```powershell
.\scripts\publish-dotnet-release.ps1 -Version "0.1.0" -Upload
```

Current downloadable package:

[AvevaE3D.CustomTools 0.1.0](https://github.com/mikhalchankasm/aveva-e3d-pmllib-custom/releases/tag/dotnet-tools-v0.1.0)

## PMLNet Class

```text
AvevaE3D.CustomTools.Copy.CopyTools
```

Initial callable methods:

```text
Version()
MaxNameLength()
IndexedPrefix(prefixRoot, copyIndex)
BaseName(sourceName)
BuildName(sourceName, elementType, prefixRoot, copyIndex, nameMode)
IsWithinNameLimit(fullName)
```

## Next Step

The current C# code only builds/validates COPYCE names. The next step is to add either:

- a PML wrapper that calls `CopyTools.BuildName()` for preview/validation; or
- a database-aware C# copy service using AVEVA database APIs after undo/transaction behavior is confirmed in E3D 2.10.
