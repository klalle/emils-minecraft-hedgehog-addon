# Bygger dist/<addon>.mcaddon (en zip med BP + RP) för en eller alla addons.
# Användning:  .\tools\build.ps1            (alla)
#              .\tools\build.ps1 starter    (en)
param([string]$Addon)

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null

$addons = if ($Addon) { @(Get-Item (Join-Path $root "addons\$Addon")) } else { Get-ChildItem (Join-Path $root 'addons') -Directory }

foreach ($a in $addons) {
  foreach ($p in 'BP', 'RP') {
    $m = Join-Path $a.FullName "$p\manifest.json"
    if (-not (Test-Path $m)) { throw "Saknar $m" }
    Get-Content $m -Raw | ConvertFrom-Json | Out-Null   # validerar JSON
  }
  $zip = Join-Path $dist "$($a.Name).zip"
  $out = Join-Path $dist "$($a.Name).mcaddon"
  Remove-Item $zip, $out -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $a.FullName 'BP'), (Join-Path $a.FullName 'RP') -DestinationPath $zip
  Rename-Item $zip "$($a.Name).mcaddon"
  Write-Host "Byggde $out"
}
