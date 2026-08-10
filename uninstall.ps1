$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA) -or [string]::IsNullOrWhiteSpace($env:APPDATA)) {
    throw 'Le cartelle personali di Windows non sono disponibili.'
}

$InstallFolder = Join-Path $env:LOCALAPPDATA 'Programs\MG Windows Toolbox'
$StartMenuFolder = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
$ShortcutPath = Join-Path $StartMenuFolder 'M.G Windows Toolbox.lnk'

if (Test-Path -LiteralPath $ShortcutPath) {
    Remove-Item -LiteralPath $ShortcutPath -Force
    Write-Host "Collegamento rimosso: $ShortcutPath"
}

if (Test-Path -LiteralPath $InstallFolder) {
    Remove-Item -LiteralPath $InstallFolder -Recurse -Force
    Write-Host "Cartella rimossa: $InstallFolder"
}

Write-Host 'Disinstallazione completata.' -ForegroundColor Green
