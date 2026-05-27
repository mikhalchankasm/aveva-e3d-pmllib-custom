# .NET tools

This folder is reserved for optional C# source code used by PML wrappers.

Do not commit compiled `.dll` files here. Build outputs should stay local and release binaries should be attached to GitHub Releases.

Expected layout:

```text
src/dotnet/<tool-project>/
  README.md
  *.csproj
  *.cs
```

See [../../docs/dotnet-tools.md](../../docs/dotnet-tools.md) for the repository rules.
