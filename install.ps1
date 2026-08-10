$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$DownloadUrl = 'https://github.com/gregoriomangano/mg-windows-toolbox/releases/download/v0.3.0-beta.1/MG_Windows_Toolbox_0.3.0-beta.1_win64.zip'
$ExpectedSha256 = '829478B663C2585226DEC185B6A1B3857B7C5CDDA0793F281975F17AAB15F067'
$PackageFolderName = 'M.G Windows Toolbox-win32-x64'
$ExecutableName = 'M.G Windows Toolbox.exe'

if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA) -or [string]::IsNullOrWhiteSpace($env:APPDATA)) {
    throw 'Le cartelle personali di Windows non sono disponibili.'
}

$InstallFolder = Join-Path $env:LOCALAPPDATA 'Programs\MG Windows Toolbox'
$StartMenuFolder = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
$ShortcutPath = Join-Path $StartMenuFolder 'M.G Windows Toolbox.lnk'
$TemporaryFolder = Join-Path ([System.IO.Path]::GetTempPath()) ('mg-windows-toolbox-' + [guid]::NewGuid().ToString('N'))
$ZipPath = Join-Path $TemporaryFolder 'MG_Windows_Toolbox_0.3.0-beta.1_win64.zip'
$ExtractFolder = Join-Path $TemporaryFolder 'estratto'

if (Test-Path -LiteralPath $InstallFolder) {
    throw "La cartella di installazione esiste gia: $InstallFolder`nPer reinstallare, esegui prima uninstall.ps1."
}

try {
    New-Item -ItemType Directory -Path $TemporaryFolder | Out-Null

    Write-Host 'Download della release ufficiale v0.3.0-beta.1...'
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath

    Write-Host 'Verifica del checksum SHA-256...'
    $ActualSha256 = (Get-FileHash -LiteralPath $ZipPath -Algorithm SHA256).Hash.ToUpperInvariant()
    if ($ActualSha256 -ne $ExpectedSha256) {
        throw "Checksum non valido. Installazione interrotta.`nAtteso: $ExpectedSha256`nTrovato: $ActualSha256"
    }

    New-Item -ItemType Directory -Path $ExtractFolder | Out-Null
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $ExtractFolder

    $ExtractedProgram = Join-Path $ExtractFolder $PackageFolderName
    $ExtractedExecutable = Join-Path $ExtractedProgram $ExecutableName
    if (-not (Test-Path -LiteralPath $ExtractedExecutable -PathType Leaf)) {
        throw 'Il pacchetto non contiene il programma nel percorso previsto.'
    }

    $InstallParent = Split-Path -Parent $InstallFolder
    New-Item -ItemType Directory -Path $InstallParent -Force | Out-Null
    Move-Item -LiteralPath $ExtractedProgram -Destination $InstallFolder

    $InstalledExecutable = Join-Path $InstallFolder $ExecutableName
    New-Item -ItemType Directory -Path $StartMenuFolder -Force | Out-Null
    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $InstalledExecutable
    $Shortcut.WorkingDirectory = $InstallFolder
    $Shortcut.IconLocation = "$InstalledExecutable,0"
    $Shortcut.Save()

    Write-Host ''
    Write-Host 'Installazione completata.' -ForegroundColor Green
    Write-Host "Programma: $InstalledExecutable"
    Write-Host 'Collegamento: menu Start > M.G Windows Toolbox'
}
finally {
    if (Test-Path -LiteralPath $TemporaryFolder) {
        Remove-Item -LiteralPath $TemporaryFolder -Recurse -Force
    }
}
