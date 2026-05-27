param(
    [string]$E3DVersion = "Everything3D2.10",
    [string]$PmlLibRoot
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "pmllib\mylib"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Source folder not found: $source"
}

if ([string]::IsNullOrWhiteSpace($PmlLibRoot)) {
    $PmlLibRoot = Join-Path "C:\Program Files (x86)\AVEVA" "$E3DVersion\PMLLIB"
}

if (-not (Test-Path -LiteralPath $PmlLibRoot)) {
    throw "Target PMLLIB root not found: $PmlLibRoot"
}

$target = Join-Path $PmlLibRoot "mylib"
New-Item -ItemType Directory -Path $target -Force | Out-Null

Copy-Item -Path (Join-Path $source "*") -Destination $target -Recurse -Force

Write-Host "Installed custom PMLLIB files to: $target"
