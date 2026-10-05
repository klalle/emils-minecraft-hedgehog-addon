# Sätter version i alla manifest för ett addon och lägger versionen i paketnamnet
# ("Starter BP 1.28.1"), så att olika versioner går att skilja åt i Minecraft.
#   .\tools\bump-version.ps1 1.28.1            (addon "starter")
#   .\tools\bump-version.ps1 1.29.0 -Addon starter
param(
  [Parameter(Mandatory)][ValidatePattern('^\d+\.\d+\.\d+$')][string]$Version,
  [string]$Addon = 'starter'
)

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$parts = $Version.Split('.') -join ', '

foreach ($p in 'BP', 'RP') {
  $file = Join-Path $root "addons\$Addon\$p\manifest.json"
  $t = Get-Content $file -Raw -Encoding UTF8
  # "version": [x, y, z]  (rör inte "min_engine_version")
  $t = [regex]::Replace($t, '(?<![_\w])"version":\s*\[\d+,\s*\d+,\s*\d+\]', "`"version`": [$parts]")
  # Paketnamn: "Starter BP" / "Starter BP 1.2.3" -> "Starter BP <version>"
  $t = [regex]::Replace($t, '"name":\s*"(Starter (?:BP|RP))(?:\s+\d+\.\d+\.\d+)?"', "`"name`": `"`$1 $Version`"")
  Set-Content $file $t -Encoding UTF8
  $null = $t | ConvertFrom-Json   # validerar JSON
  Write-Host "$p -> $Version"
}
