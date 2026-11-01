param(
    [string]$GameDir = ''
)
# ============================================================
#  GORNILO EVOLUCII - portable launcher (Minecraft 1.7.10 Forge)
#  Works on any PC with Java 8 installed.
#  Usage:  Start.bat   (or: powershell -File launch.ps1 -GameDir "C:\path\.minecraft")
# ============================================================
$ErrorActionPreference = 'Continue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not $GameDir) {
    $cfgFile = Join-Path $here 'game-dir.txt'
    if (Test-Path $cfgFile) { $GameDir = (Get-Content $cfgFile -Raw).Trim() }
}
if (-not $GameDir) { $GameDir = Join-Path $env:APPDATA '.minecraft1710' }
if (-not (Test-Path $GameDir)) {
    Write-Host ('[!] Game directory not found: ' + $GameDir) -ForegroundColor Red
    Write-Host '    Edit launcher\game-dir.txt and put the path to your Minecraft 1.7.10 Forge instance.' -ForegroundColor Yellow
    Read-Host 'Press Enter to exit'
    exit 1
}

$verName = '1.7.10-Forge10.13.4.1614-1.7.10'
$verDir = Join-Path $GameDir ('versions\' + $verName)
$verJson = Join-Path $verDir ($verName + '.json')
if (-not (Test-Path $verJson)) {
    Write-Host ('[!] Forge profile not found: ' + $verJson) -ForegroundColor Red
    Write-Host '    Install Minecraft Forge 1.7.10-10.13.4.1614 for this instance first.' -ForegroundColor Yellow
    Read-Host 'Press Enter to exit'
    exit 1
}

# --- find Java 8 ---
function Find-Java8 {
    $candidates = @()
    if ($env:JAVA8_HOME) { $candidates += (Join-Path $env:JAVA8_HOME 'bin\javaw.exe') }
    $candidates += 'C:\Program Files\Java\jre-1.8\bin\javaw.exe'
    $candidates += 'C:\Program Files\Java\jdk1.8.0_401\bin\javaw.exe'
    $candidates += 'C:\Program Files (x86)\Java\jre-1.8\bin\javaw.exe'
    foreach ($p in $candidates) { if (Test-Path $p) { return $p } }
    # scan Program Files\Java
    if (Test-Path 'C:\Program Files\Java') {
        $hit = Get-ChildItem 'C:\Program Files\Java' -Directory | ForEach-Object { Join-Path $_.FullName 'bin\javaw.exe' } | Where-Object { Test-Path $_ } | Select-Object -First 1
        if ($hit) { return $hit }
    }
    # scan for any java.exe on PATH
    $cmd = Get-Command 'javaw.exe' -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}
$javaw = Find-Java8
if (-not $javaw) {
    Write-Host '[!] Java 8 (1.8) not found. Install it: https://adoptium.net/temurin/releases/?version=8' -ForegroundColor Red
    Read-Host 'Press Enter to exit'
    exit 1
}

# --- build classpath from the Forge version json ---
$json = Get-Content $verJson -Raw | ConvertFrom-Json
$cp = @(Join-Path $verDir ($verName + '.jar'))
foreach ($lib in $json.libraries) {
    $p = $null
    if ($lib.artifact) { $p = $lib.artifact.path }
    if ($p) {
        $rel = $p -replace '/', '\'
        if ($rel -match '^libraries\\') { $full = Join-Path $GameDir $rel } else { $full = Join-Path $GameDir ('libraries\' + $rel) }
        if (Test-Path $full) { $cp += $full }
    }
}
$natives = Join-Path $verDir 'natives'
if (Test-Path $natives) { $cp += $natives }
$cpStr = ($cp -join ';')

# --- game args ---
$argsLine = $json.minecraftArguments
$repl = @{
    '${auth_player_name}'  = 'Player'
    '${version_name}'      = $verName
    '${game_directory}'    = $GameDir
    '${assets_root}'       = (Join-Path $GameDir 'assets')
    '${assets_index_name}' = '1.7.10'
    '${auth_uuid}'         = '00000000000000000000000000000000'
    '${auth_access_token}' = '0'
    '${user_type}'         = 'legacy'
    '${user_properties}'   = '{}'
}
foreach ($k in $repl.Keys) { $argsLine = $argsLine.Replace($k, [string]$repl[$k]) }
$gameArgs = @($argsLine -split ' ') + @('--width', '1920', '--height', '1080')

$cmd = @(
    '-Xms2048M', '-Xmx4096M',
    '-XX:+UseConcMarkSweepGC',
    "-Djava.library.path=$natives",
    '-Dfml.ignoreInvalidMinecraftCertificates=true',
    '-Dfml.ignorePatchDiscrepancies=true',
    '-cp', $cpStr,
    'net.minecraft.launchwrapper.Launch'
) + $gameArgs

$quoted = @()
foreach ($a in $cmd) { if ($a -match '\s') { $quoted += ('"' + $a + '"') } else { $quoted += $a } }
$argString = $quoted -join ' '

Write-Host ('[Gornilo] Java: ' + $javaw)
Write-Host ('[Gornilo] Game dir: ' + $GameDir)
Write-Host '[Gornilo] Starting Minecraft 1.7.10 ...'

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $javaw
$psi.Arguments = $argString
$psi.WorkingDirectory = $GameDir
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$proc = [System.Diagnostics.Process]::Start($psi)
$proc.BeginOutputReadLine()
$proc.BeginErrorReadLine()
Write-Host ('[Gornilo] PID ' + $proc.Id + ' — play! Press Ctrl+C here to leave the launcher (game keeps running).')
while (-not $proc.HasExited) { Start-Sleep -Seconds 5 }
Write-Host ('[Gornilo] Game exited with code ' + $proc.ExitCode)
