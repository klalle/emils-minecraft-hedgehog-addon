# Lokal Bedrock-testserver (server/ i projektet).
#   .\tools\server.ps1 setup            skriver labb-inställningar i server.properties (en gång)
#   .\tools\server.ps1 deploy [addon]   kopierar packs till servern och aktiverar dem i världen
#   .\tools\server.ps1 start            startar servern (Ctrl+C eller skriv "stop" för att stoppa)
param(
  [Parameter(Mandatory)][ValidateSet('setup', 'deploy', 'start')][string]$Command,
  [string]$Addon
)

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$srv = Join-Path $root 'server'
if (-not (Test-Path "$srv\bedrock_server.exe")) { throw "Servern saknas i $srv" }

function Set-Prop($name, $value) {
  $f = "$srv\server.properties"
  $t = Get-Content $f
  if ($t -match "^$name=") { $t = $t -replace "^$name=.*", "$name=$value" } else { $t += "$name=$value" }
  Set-Content $f $t
}

switch ($Command) {
  'setup' {
    Set-Prop 'server-name' 'Labb-server'
    Set-Prop 'level-name' 'labb'
    Set-Prop 'gamemode' 'creative'
    Set-Prop 'difficulty' 'peaceful'
    Set-Prop 'allow-cheats' 'true'
    Set-Prop 'online-mode' 'true'
    Set-Prop 'allow-list' 'false'
    Set-Prop 'content-log-console-output-enabled' 'true'
    Set-Prop 'default-player-permission-level' 'operator'
    Set-Prop 'texturepack-required' 'true'
    Write-Host 'server.properties uppdaterad.'
  }
  'deploy' {
    $level = ((Get-Content "$srv\server.properties") -match '^level-name=') -replace 'level-name=', ''
    $world = Join-Path $srv "worlds\$level"
    New-Item -ItemType Directory -Force $world | Out-Null
    $addons = if ($Addon) { @($Addon) } else { (Get-ChildItem "$root\addons" -Directory).Name }
    $bp = @(); $rp = @()
    foreach ($a in $addons) {
      foreach ($p in @(@('BP', 'behavior_packs'), @('RP', 'resource_packs'))) {
        $dst = Join-Path $srv "$($p[1])\$a`_$($p[0])"
        Remove-Item $dst -Recurse -Force -ErrorAction SilentlyContinue
        Copy-Item "$root\addons\$a\$($p[0])" $dst -Recurse
        $m = Get-Content "$dst\manifest.json" -Raw | ConvertFrom-Json
        $entry = @{ pack_id = $m.header.uuid; version = $m.header.version }
        if ($p[0] -eq 'BP') { $bp += $entry } else { $rp += $entry }
      }
      Write-Host "Kopierade $a"
    }
    # Dev-only pack (alltid dag m.m.), delas aldrig: ligger i dev/, inte addons/
    $devSrc = "$root\dev\dev-tools\BP"
    if (Test-Path $devSrc) {
      $dst = Join-Path $srv 'behavior_packs\dev-tools_BP'
      Remove-Item $dst -Recurse -Force -ErrorAction SilentlyContinue
      Copy-Item $devSrc $dst -Recurse
      $m = Get-Content "$dst\manifest.json" -Raw | ConvertFrom-Json
      $bp += @{ pack_id = $m.header.uuid; version = $m.header.version }
      Write-Host 'Kopierade dev-tools'
    }
    ConvertTo-Json -InputObject $bp -Depth 5 | Set-Content "$world\world_behavior_packs.json"
    ConvertTo-Json -InputObject $rp -Depth 5 | Set-Content "$world\world_resource_packs.json"
    Write-Host "Aktiverade packs i världen '$level'. Starta om servern."
  }
  'start' {
    Push-Location $srv
    try { & .\bedrock_server.exe } finally { Pop-Location }
  }
}


