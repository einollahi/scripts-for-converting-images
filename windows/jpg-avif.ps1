<#
    JPG/PNG → AVIF Converter Script
    --------------------------------
    Author: Alireza Einollahi
    Version: 1.1
    Platform: Windows PowerShell

    DESCRIPTION:
      This script converts all .jpg and .png images inside a folder into .avif
      using ImageMagick. After a successful conversion, the original file
      (jpg/png) is automatically deleted. The script supports recursive folder
      scanning and includes defaults so it can be run without any parameters.

    REQUIREMENTS:
      - Windows PowerShell
      - ImageMagick installed (https://imagemagick.org)
      - "magick" command must be available in PATH
      - Execution policy must allow running local scripts:
            Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

    DEFAULT BEHAVIOR (when run without parameters):
      - Folder: current directory (.)
      - Recurse into subfolders: true
      - Output format: avif

    USAGE:
      Basic (convert all .jpg/.png → .avif in current folder and subfolders):
        .\jpg-png-to-avif.ps1

      Convert only current folder (no subfolders):
        .\jpg-png-to-avif.ps1 -Recurse $false

      Convert a specific folder:
        .\jpg-png-to-avif.ps1 -Folder "D:\Images"

    OUTPUT:
      - Shows each file being converted
      - Indicates success/failure
      - Deletes original file only after successful conversion
#>

param(
    [string]$Folder = ".",
    [bool]$Recurse = $true
)

Write-Host "=== JPG/PNG → AVIF Converter ==="
Write-Host "Folder : $Folder"
Write-Host "Recurse: $Recurse"
Write-Host ""

$gciParams = @{
    Path  = $Folder
    File  = $true
}

if ($Recurse) {
    $gciParams["Recurse"] = $true
}

$files = Get-ChildItem @gciParams | Where-Object {
    $_.Extension -in ".jpg", ".jpeg", ".png"
}

if (-not $files) {
    Write-Host "No .jpg or .png files found."
    return
}

foreach ($file in $files) {
    $src = $file.FullName
    $dest = [System.IO.Path]::ChangeExtension($src, "avif")

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
