# .NET-backed PML helpers

This repository may contain optional .NET/C# source code for helpers whose logic is difficult to maintain in plain PML.

The recommended model is:

```text
PML wrapper -> custom C# tool -> result returned to PML or applied through an agreed E3D integration point
```

## Repository Rules

- Keep PML entrypoints under `pmllib/`.
- Keep C# source code under `src/dotnet/`.
- Do not commit compiled `.dll` files to git.
- Publish DLL builds through GitHub Releases.
- Document every DLL-backed helper next to its PML wrapper.
- Keep AVEVA licensed binaries and vendor files out of this repository.

## Suggested Structure

```text
pmllib/
  mylib/
    design/
      copyfunc/
        copyCeNet.pmlfnc
        README.md
src/
  dotnet/
    AvevaE3D.CustomTools.sln
    AvevaE3D.CustomTools/
      README.md
      *.csproj
      *.cs
docs/
  copyce-net.md
```

## What PML Should Do

PML should stay responsible for the E3D-facing workflow:

- read the current `CE` and relevant owner/context;
- create `MARKDB` undo marks where appropriate;
- call the custom .NET tool through the chosen integration method;
- apply returned commands or results only after validation;
- show clear errors to the user.

## What C# Should Do

C# is a better place for complex or fast-changing logic:

- build naming plans;
- validate E3D name-length limits;
- resolve collisions and repeated-copy indexes;
- parse configuration;
- run deterministic tests outside E3D where possible;
- keep project-specific rules isolated from PML syntax noise.

## Release Checklist

For each published DLL release, include:

- tool name and version;
- supported E3D/PDMS version;
- .NET target and CPU architecture;
- installation path;
- matching PML wrapper version;
- checksum;
- short changelog.

## COPYCE Direction

The current `COPYCE` helper is implemented in PML. A DLL-backed layer has started in `src/dotnet/AvevaE3D.CustomTools/` with `AvevaE3D.CustomTools.Copy.CopyTools`.

The first PMLNet wrapper is:

```text
pmllib/mylib/design/copyfunc/copyCeNetBuildName.pmlfnc
```

It calls the C# naming logic only. A future entrypoint, for example `copyCeNet.pmlfnc`, can perform more of the actual copy workflow after undo/transaction behavior is confirmed in E3D 2.10.

That keeps the simple public PML implementation available while allowing a richer C# implementation for advanced copy behavior.
