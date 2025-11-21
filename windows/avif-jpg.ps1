<#
    AVIF → JPG/PNG Converter Script
    --------------------------------
    Author: Alireza Einollahi
    Version: 1.0
    Platform: Windows PowerShell

    DESCRIPTION:
      This script converts all .avif images inside a folder into .jpg or .png
      using ImageMagick. After a successful conversion, the original .avif file
      is automatically deleted. The script supports recursive folder scanning
      and includes defaults so it can be run without any parameters.

    REQUIREMENTS:
      - Windows PowerShell
      - ImageMagick installed (https://imagemagick.org)
      - "magick" command must be available in PATH
      - Execution policy must allow running local scripts:
            Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

    DEFAULT BEHAVIOR (when run without parameters):
      - Folder: current directory (.)
      - Output format: jpg
      - Recurse into subfolders: true

    USAGE:
      Basic (convert all .avif → .jpg in current folder and subfolders):
        .\avif-jpg.ps1

      Convert to PNG:
        .\avif-jpg.ps1 -Format png

      Convert only current folder (no subfolders):
        .\avif-jpg.ps1 -Recurse $false

      Convert a specific folder:
        .\avif-jpg.ps1 -Folder "D:\Images"

    OUTPUT:
      - Shows each file being converted
      - Indicates success/failure
      - Deletes original .avif only after successful conversion

#>

param(
    [string]$Folder = ".",

    [ValidateSet("jpg","png")]
    [string]$Format = "jpg",

    [bool]$Recurse = $true
)

Write-Host "=== AVIF Converter ==="
Write-Host "Folder : $Folder"
Write-Host "Format : $Format"
Write-Host "Recurse: $Recurse"
Write-Host ""

$gciParams = @{
    Path   = $Folder
    Filter = "*.avif"
    File   = $true
}

if ($Recurse) {
    $gciParams["Recurse"] = $true
}

$files = Get-ChildItem @gciParams

if (-not $files) {
    Write-Host "No .avif files found."
    return
}

foreach ($file in $files) {
    $src  = $file.FullName
    $dest = [System.IO.Path]::ChangeExtension($src, $Format)

    Write-Host "Converting: $src"

    & magick "$src" "$dest"

    if ($LASTEXITCODE -eq 0 -and (Test-Path $dest)) {
        Remove-Item $src
        Write-Host "  OK  -> $dest (original deleted)"
    }
    else {
        Write-Warning "  Failed. Original kept."
    }
}

Write-Host ""
Write-Host "Done."
