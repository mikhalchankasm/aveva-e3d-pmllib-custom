param(
    [string]$Version = "0.1.0",
    [string]$E3DInstallDir = "C:\Program Files (x86)\AVEVA\Everything3D2.10",
    [string]$Configuration = "Release",
    [string]$Platform = "x86",
    [switch]$Upload
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$solution = Join-Path $repoRoot "src\dotnet\AvevaE3D.CustomTools.sln"
$projectDir = Join-Path $repoRoot "src\dotnet\AvevaE3D.CustomTools"
$outputDir = Join-Path $projectDir "bin\$Platform\$Configuration"
$dllPath = Join-Path $outputDir "AvevaE3D.CustomTools.dll"
$releaseRoot = Join-Path $repoRoot "dist\dotnet"
$packageDir = Join-Path $releaseRoot "AvevaE3D.CustomTools-$Version"
$zipPath = Join-Path $releaseRoot "AvevaE3D.CustomTools-$Version-e3d210-$Platform.zip"
$checksumPath = "$zipPath.sha256"
$tag = "dotnet-tools-v$Version"

function Assert-ChildPath {
    param(
        [string]$Parent,
        [string]$Child
    )

    $parentFull = [System.IO.Path]::GetFullPath($Parent).TrimEnd('\') + '\'
    $childFull = [System.IO.Path]::GetFullPath($Child).TrimEnd('\') + '\'

    if (-not $childFull.StartsWith($parentFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to operate outside expected directory. Parent=$parentFull Child=$childFull"
    }
}

if (-not (Test-Path (Join-Path $E3DInstallDir "PMLNet.dll"))) {
    throw "PMLNet.dll was not found under E3DInstallDir: $E3DInstallDir"
}

dotnet msbuild $solution `
    /p:E3DInstallDir="$E3DInstallDir" `
    /p:Configuration=$Configuration `
    /p:Platform=$Platform

if (-not (Test-Path $dllPath)) {
    throw "Build completed but DLL was not found: $dllPath"
}

if (Test-Path $packageDir) {
    Assert-ChildPath -Parent $releaseRoot -Child $packageDir
    Remove-Item -LiteralPath $packageDir -Recurse -Force
}

New-Item -ItemType Directory -Path $packageDir | Out-Null
Copy-Item -LiteralPath $dllPath -Destination $packageDir

$readme = @"
# AvevaE3D.CustomTools $Version

Target: AVEVA E3D 2.10 / PMLNet
Framework: .NET Framework 4.0
Platform: $Platform

Install the DLL into the PMLNet load path used by your E3D setup, then use the PML wrappers from this repository.

This package contains only user-authored binaries. It does not include AVEVA DLLs.
"@

Set-Content -Path (Join-Path $packageDir "README.txt") -Value $readme -Encoding ASCII

if (Test-Path $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
}

Compress-Archive -Path (Join-Path $packageDir "*") -DestinationPath $zipPath -Force

$hash = Get-FileHash -Algorithm SHA256 -Path $zipPath
Set-Content -Path $checksumPath -Value "$($hash.Hash)  $(Split-Path -Leaf $zipPath)" -Encoding ASCII

Write-Host "Created package:"
Write-Host "  $zipPath"
Write-Host "  $checksumPath"

if ($Upload) {
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    gh release view $tag 1>$null 2>$null
    $releaseExists = ($LASTEXITCODE -eq 0)
    $ErrorActionPreference = $oldErrorActionPreference

    if (-not $releaseExists) {
        gh release create $tag $zipPath $checksumPath `
            --title "AvevaE3D.CustomTools $Version" `
            --notes "PMLNet tools package for AVEVA E3D 2.10. Built locally because AVEVA PMLNet.dll is not available on GitHub-hosted runners."
    }
    else {
        gh release upload $tag $zipPath $checksumPath --clobber
    }
}
