param(
    [string]$E3DVersion = "Everything3D2.10",
    [string]$PmlLibRoot,
    [string]$LibraryName = "e3dctools"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "pmllib\e3dctools"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Source folder not found: $source"
}

if ([string]::IsNullOrWhiteSpace($LibraryName)) {
    throw "LibraryName must not be empty."
}

if ([string]::IsNullOrWhiteSpace($PmlLibRoot)) {
    $PmlLibRoot = Join-Path "C:\Program Files (x86)\AVEVA" "$E3DVersion\PMLLIB"
}

if (-not (Test-Path -LiteralPath $PmlLibRoot)) {
    throw "Target PMLLIB root not found: $PmlLibRoot"
}

$target = Join-Path $PmlLibRoot $LibraryName
New-Item -ItemType Directory -Path $target -Force | Out-Null

Copy-Item -Path (Join-Path $source "*") -Destination $target -Recurse -Force

Write-Host "Installed custom PMLLIB files to: $target"
