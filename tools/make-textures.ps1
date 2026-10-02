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
Fill $b 0 27 8 31 225 205 160 6            # synliga taggar (ljusa)
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

# Taggsköld, ikon 16x16: vanlig sköldform med järnkant, trä och taggar
$b = New-Object System.Drawing.Bitmap 16, 16
$iron = C 85 85 92; $bone = C 235 220 180
for ($y = 1; $y -le 14; $y++) {
  $inset = if ($y -ge 11) { $y - 10 } else { 0 }            # smalnar av nedtill
  for ($x = 3 + $inset; $x -le 12 - $inset; $x++) {
    $edge = ($x -eq 3 + $inset -or $x -eq 12 - $inset -or $y -eq 1 -or $y -eq 14)
    $b.SetPixel($x, $y, $(if ($edge) { $iron } else { C (140 + $rnd.Next(-9, 9)) (95 + $rnd.Next(-9, 9)) 55 }))
  }
}
for ($y = 2; $y -le 12; $y++) { $b.SetPixel(7, $y, $iron); $b.SetPixel(8, $y, $iron) }   # mittribba
foreach ($p in @(@(3, 0), @(12, 0), @(1, 5), @(14, 5), @(7, 15), @(8, 15), @(5, 13), @(10, 13), @(1, 2), @(14, 2))) { $b.SetPixel($p[0], $p[1], $bone) }
$b.SetPixel(7, 7, $bone); $b.SetPixel(8, 7, $bone); $b.SetPixel(7, 8, $bone); $b.SetPixel(8, 8, $bone)   # taggbulle
Save $b "$rp\items\thorn_shield.png"

# Taggsköld, modelltextur 64x64 (UV enligt thorn_shield.geo.json)
$b = New-Object System.Drawing.Bitmap 64, 64
$wood = { C (140 + $rnd.Next(-9, 9)) (95 + $rnd.Next(-9, 9)) 55 }
for ($x = 0; $x -lt 26; $x++) { for ($y = 0; $y -lt 23; $y++) { $b.SetPixel($x, $y, (& $wood)) } }    # skivan
foreach ($ox in 1, 14) {                                                                              # fram- och baksida: järnkant + mittribba
  for ($x = $ox; $x -lt $ox + 12; $x++) { $b.SetPixel($x, 1, $iron); $b.SetPixel($x, 22, $iron) }
  for ($y = 1; $y -lt 23; $y++) { $b.SetPixel($ox, $y, $iron); $b.SetPixel($ox + 11, $y, $iron) }
  for ($y = 2; $y -lt 22; $y++) { $b.SetPixel($ox + 5, $y, $iron); $b.SetPixel($ox + 6, $y, $iron) }
}
for ($x = 26; $x -lt 42; $x++) { for ($y = 0; $y -lt 12; $y++) { $b.SetPixel($x, $y, (C (95 + $rnd.Next(-6, 6)) 95 100)) } }   # handtag
for ($x = 0; $x -lt 18; $x++) { for ($y = 30; $y -lt 35; $y++) { $b.SetPixel($x, $y, $bone) } }      # taggar (ben)
Save $b "$rp\attachables\thorn_shield.png"

# Taggfälla 16x16: stålplatta med nitar (taggarna använder pixeln (2,2) som färg)
$b = New-Object System.Drawing.Bitmap 16, 16
for ($x = 0; $x -lt 16; $x++) { for ($y = 0; $y -lt 16; $y++) {
  $edge = ($x -eq 0 -or $y -eq 0 -or $x -eq 15 -or $y -eq 15)
  $b.SetPixel($x, $y, $(if ($edge) { C 60 60 66 } else { $d = $rnd.Next(-8, 8); C (130 + $d) (134 + $d) (142 + $d) })) } }
foreach ($p in @(@(2, 2), @(13, 2), @(2, 13), @(13, 13))) { $b.SetPixel($p[0], $p[1], (C 205 210 218)) }
Save $b "$rp\blocks\spike_trap.png"
Write-Host 'Texturer genererade.'



