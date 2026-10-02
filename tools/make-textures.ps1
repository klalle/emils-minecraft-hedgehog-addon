# Genererar enkla platshållartexturer (igelkott, tagg, taggsköld). Byt gärna ut PNG-filerna mot egen pixelkonst.
Add-Type -AssemblyName System.Drawing
$rp = Join-Path $PSScriptRoot '..\addons\starter\RP\textures'
$rnd = New-Object System.Random 7
function Cl($v) { [int][math]::Max(0, [math]::Min(255, $v)) }
function C($r, $g, $b) { [System.Drawing.Color]::FromArgb(255, (Cl $r), (Cl $g), (Cl $b)) }
function Fill($bmp, $x0, $y0, $x1, $y1, $r, $g, $b, $jit) {
  for ($x = $x0; $x -lt $x1; $x++) { for ($y = $y0; $y -lt $y1; $y++) {
    $d = $rnd.Next(-$jit, $jit + 1); $bmp.SetPixel($x, $y, (C ($r + $d) ($g + $d) ($b + $d))) } }
}
function Save($bmp, $path) { $dir = Split-Path $path; New-Item -ItemType Directory -Force $dir | Out-Null; $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose() }

# Igelkott 64x32 (UV enligt hedgehog.geo.json)
$b = New-Object System.Drawing.Bitmap 64, 32
Fill $b 0 0 64 32 120 90 60 12            # kropp
Fill $b 0 15 34 27 70 50 35 14            # taggar (mörka)
for ($i = 0; $i -lt 70; $i++) { $b.SetPixel($rnd.Next(0, 34), $rnd.Next(15, 27), (C 215 195 150)) }  # ljusa taggspetsar
Fill $b 34 0 52 8 205 175 135 8           # huvud
Fill $b 34 8 42 12 60 40 30 3             # nos
$b.SetPixel(39, 5, (C 10 10 10)); $b.SetPixel(41, 5, (C 10 10 10))   # ögon (huvudets framsida)
$b.SetPixel(40, 7, (C 20 15 15))
Fill $b 52 0 60 4 90 65 45 5              # ben
Save $b "$rp\entity\hedgehog.png"

# Tagg 16x16 (diagonal)
$b = New-Object System.Drawing.Bitmap 16, 16
for ($i = 2; $i -lt 14; $i++) { $b.SetPixel($i, 15 - $i, (C 200 175 125)); $b.SetPixel($i + 1, 15 - $i, (C 120 90 60)) }
$b.SetPixel(14, 1, (C 245 230 190))
Save $b "$rp\items\hedgehog_spine.png"

# Taggsköld 16x16
$b = New-Object System.Drawing.Bitmap 16, 16
Fill $b 3 2 13 14 130 90 50 10
for ($x = 3; $x -lt 13; $x++) { $b.SetPixel($x, 2, (C 70 70 75)); $b.SetPixel($x, 13, (C 70 70 75)) }
for ($y = 2; $y -lt 14; $y++) { $b.SetPixel(3, $y, (C 70 70 75)); $b.SetPixel(12, $y, (C 70 70 75)) }
foreach ($p in @(@(1, 1), @(14, 1), @(1, 14), @(14, 14), @(8, 0), @(8, 15), @(0, 8), @(15, 8))) { $b.SetPixel($p[0], $p[1], (C 215 195 150)) }
for ($i = 5; $i -lt 11; $i++) { $b.SetPixel($i, 7, (C 190 190 195)); $b.SetPixel(7, $i, (C 190 190 195)) }   # kors
Save $b "$rp\items\thorn_shield.png"
Write-Host 'Texturer genererade.'
