# Kopierar addonets BP/RP till Minecraft Bedrocks dev-mappar på din PC (Windows 10/11),
# så du kan testa direkt utan att importera .mcaddon. Kör igen efter varje ändring.
param([Parameter(Mandatory)][string]$Addon)

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$mojang = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang'
if (-not (Test-Path $mojang)) { throw "Hittar inte $mojang - är Minecraft Bedrock installerat?" }

foreach ($pair in @(@('BP', 'development_behavior_packs'), @('RP', 'development_resource_packs'))) {
  $src = Join-Path $root "addons\$Addon\$($pair[0])"
  $dst = Join-Path $mojang "$($pair[1])\$Addon`_$($pair[0])"
  Remove-Item $dst -Recurse -Force -ErrorAction SilentlyContinue
  Copy-Item $src $dst -Recurse
  Write-Host "Kopierade $src -> $dst"
}
Write-Host "Aktivera båda packen på en ny testvärld (Creative, Cheats på)."
