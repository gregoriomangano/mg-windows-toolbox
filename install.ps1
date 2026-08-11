$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$ReleaseTag = 'v0.3.0-beta.2'
$DownloadUrl = "https://github.com/gregoriomangano/mg-windows-toolbox/releases/download/$ReleaseTag/MG_Windows_Toolbox_0.3.0-beta.2_win64.zip"
$ExpectedSha256 = 'FF3D7AB04D091C99818BE827272A73BC079BD31DC28C968B272BD0F1AA75A2EA'
$PackageFolderName = 'M.G Windows Toolbox-win32-x64'
$ExecutableName = 'M.G Windows Toolbox.exe'

if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA) -or [string]::IsNullOrWhiteSpace($env:APPDATA)) {
    throw 'Le cartelle personali di Windows non sono disponibili.'
}

$InstallFolder = Join-Path $env:LOCALAPPDATA 'Programs\MG Windows Toolbox'
$InstalledExecutable = Join-Path $InstallFolder $ExecutableName
$UserDataFolder = Join-Path $env:APPDATA 'M.G Windows Toolbox'
$StartMenuFolder = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
$ShortcutPath = Join-Path $StartMenuFolder 'M.G Windows Toolbox.lnk'
$TemporaryFolder = Join-Path ([System.IO.Path]::GetTempPath()) ('mg-windows-toolbox-' + [guid]::NewGuid().ToString('N'))
$ZipPath = Join-Path $TemporaryFolder 'MG_Windows_Toolbox_0.3.0-beta.2_win64.zip'
$ExtractFolder = Join-Path $TemporaryFolder 'estratto'
$PreviousFolder = $null

function Stop-InstalledToolbox {
    if (-not (Test-Path -LiteralPath $InstalledExecutable -PathType Leaf)) { return }
    $target = [System.IO.Path]::GetFullPath($InstalledExecutable)
    $processName = [System.IO.Path]::GetFileNameWithoutExtension($ExecutableName)
    $running = @(Get-Process -Name $processName -ErrorAction SilentlyContinue | Where-Object {
        try { $_.Path -and [System.IO.Path]::GetFullPath($_.Path) -eq $target } catch { $false }
    })
    if ($running.Count -eq 0) { return }

    Write-Host 'Chiusura della versione installata...' -ForegroundColor Yellow
    foreach ($process in $running) { [void]$process.CloseMainWindow() }
    $deadline = (Get-Date).AddSeconds(15)
    do {
        Start-Sleep -Milliseconds 500
        $running = @($running | Where-Object { -not $_.HasExited })
    } while ($running.Count -gt 0 -and (Get-Date) -lt $deadline)

    if ($running.Count -gt 0) {
        throw 'M.G Windows Toolbox è ancora aperto. Chiudilo normalmente e riesegui lo stesso comando: nessun file è stato sostituito.'
    }
}

function Preserve-LegacySettings {
    # Beta 1 poteva conservare la lingua dentro la cartella del programma.
    # La Beta 2 usa AppData: la migrazione è eseguita prima della sostituzione.
    $legacySettings = Join-Path $InstallFolder 'data\config.json'
    $persistentSettings = Join-Path $UserDataFolder 'settings.json'
    if ((Test-Path -LiteralPath $legacySettings -PathType Leaf) -and -not (Test-Path -LiteralPath $persistentSettings -PathType Leaf)) {
        New-Item -ItemType Directory -Path $UserDataFolder -Force | Out-Null
        Copy-Item -LiteralPath $legacySettings -Destination $persistentSettings -Force
    }
}

function Create-StartMenuShortcut {
    New-Item -ItemType Directory -Path $StartMenuFolder -Force | Out-Null
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($ShortcutPath)
    $shortcut.TargetPath = $InstalledExecutable
    $shortcut.WorkingDirectory = $InstallFolder
    $shortcut.IconLocation = "$InstalledExecutable,0"
    $shortcut.Save()
}

try {
    New-Item -ItemType Directory -Path $TemporaryFolder | Out-Null

    Write-Host "Download della release ufficiale $ReleaseTag..."
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath

    Write-Host 'Verifica del checksum SHA-256...'
    $actualSha256 = (Get-FileHash -LiteralPath $ZipPath -Algorithm SHA256).Hash.ToUpperInvariant()
    if ($actualSha256 -ne $ExpectedSha256) {
        throw "Checksum non valido. Installazione interrotta prima di qualsiasi sostituzione.`nAtteso: $ExpectedSha256`nTrovato: $actualSha256"
    }

    New-Item -ItemType Directory -Path $ExtractFolder | Out-Null
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $ExtractFolder
    $extractedProgram = Join-Path $ExtractFolder $PackageFolderName
    $extractedExecutable = Join-Path $extractedProgram $ExecutableName
    if (-not (Test-Path -LiteralPath $extractedExecutable -PathType Leaf)) {
        throw 'Il pacchetto non contiene il programma nel percorso previsto.'
    }

    $isUpdate = Test-Path -LiteralPath $InstallFolder
    if ($isUpdate -and -not (Test-Path -LiteralPath $InstalledExecutable -PathType Leaf)) {
        throw "La cartella esistente non sembra un'installazione gestita dal Toolbox: $InstallFolder"
    }

    if ($isUpdate) {
        Preserve-LegacySettings
        Stop-InstalledToolbox
        $PreviousFolder = "$InstallFolder.previous-$([guid]::NewGuid().ToString('N'))"
        Move-Item -LiteralPath $InstallFolder -Destination $PreviousFolder
    } else {
        New-Item -ItemType Directory -Path (Split-Path -Parent $InstallFolder) -Force | Out-Null
    }

    try {
        Move-Item -LiteralPath $extractedProgram -Destination $InstallFolder
        if (-not (Test-Path -LiteralPath $InstalledExecutable -PathType Leaf)) {
            throw 'La sostituzione non ha prodotto l’eseguibile previsto.'
        }
        Create-StartMenuShortcut
    } catch {
        if ($PreviousFolder -and (Test-Path -LiteralPath $PreviousFolder)) {
            if (Test-Path -LiteralPath $InstallFolder) { Remove-Item -LiteralPath $InstallFolder -Recurse -Force }
            Move-Item -LiteralPath $PreviousFolder -Destination $InstallFolder
            $PreviousFolder = $null
        }
        throw
    }

    if ($PreviousFolder -and (Test-Path -LiteralPath $PreviousFolder)) {
        Remove-Item -LiteralPath $PreviousFolder -Recurse -Force
    }

    Write-Host ''
    if ($isUpdate) { Write-Host 'Aggiornamento completato.' -ForegroundColor Green }
    else { Write-Host 'Installazione completata.' -ForegroundColor Green }
    Write-Host "Programma: $InstalledExecutable"
    Start-Process -FilePath $InstalledExecutable -WorkingDirectory $InstallFolder
}
finally {
    if (Test-Path -LiteralPath $TemporaryFolder) {
        Remove-Item -LiteralPath $TemporaryFolder -Recurse -Force
    }
}
