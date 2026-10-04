# Bygger dist/<addon>.mcaddon för en eller alla addons.
# En .mcaddon är en zip med två .mcpack (BP + RP), och varje .mcpack är en zip med manifest.json i roten.
# Zip-posterna skrivs med '/' (inte '\') så att Android, iOS och Windows kan importera dem.
# Användning:  .\tools\build.ps1            (alla)
#              .\tools\build.ps1 starter    (en)
param([string]$Addon)

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null

function New-Zip($zipPath, $entries) {   # $entries: @{ 'name/in/zip' = 'C:\källfil' }
  Remove-Item $zipPath -ErrorAction SilentlyContinue
  $zip = [System.IO.Compression.ZipFile]::Open($zipPath, 'Create')
  try {
    foreach ($name in ($entries.Keys | Sort-Object)) {
      [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $entries[$name], $name, 'Optimal')
    }
  } finally { $zip.Dispose() }
}

function Get-PackEntries($dir) {
  $base = (Resolve-Path $dir).Path.TrimEnd('\') + '\'
  $map = @{}
  Get-ChildItem $dir -Recurse -File | ForEach-Object { $map[$_.FullName.Substring($base.Length).Replace('\', '/')] = $_.FullName }
  $map
}

$addons = if ($Addon) { @(Get-Item (Join-Path $root "addons\$Addon")) } else { Get-ChildItem (Join-Path $root 'addons') -Directory }

foreach ($a in $addons) {
  $tmp = Join-Path $dist "_$($a.Name)"
  New-Item -ItemType Directory -Force $tmp | Out-Null
  foreach ($p in 'BP', 'RP') {
    $m = Join-Path $a.FullName "$p\manifest.json"
    if (-not (Test-Path $m)) { throw "Saknar $m" }
    Get-Content $m -Raw | ConvertFrom-Json | Out-Null   # validerar JSON
    New-Zip (Join-Path $tmp "$($a.Name)_$p.mcpack") (Get-PackEntries (Join-Path $a.FullName $p))
  }
  $out = Join-Path $dist "$($a.Name).mcaddon"
  New-Zip $out @{
    "$($a.Name)_BP.mcpack" = (Join-Path $tmp "$($a.Name)_BP.mcpack")
    "$($a.Name)_RP.mcpack" = (Join-Path $tmp "$($a.Name)_RP.mcpack")
  }
  Remove-Item $tmp -Recurse -Force
  Write-Host "Byggde $out"
}
