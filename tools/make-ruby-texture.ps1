# Genererar en enkel 16x16-textur (rubinblock). Byt gärna ut PNG-filen mot egen pixelkonst.
Add-Type -AssemblyName System.Drawing
$out = Join-Path $PSScriptRoot '..\addons\starter\RP\textures\blocks\ruby_block.png'
$bmp = New-Object System.Drawing.Bitmap 16, 16
$rnd = New-Object System.Random 42
for ($x = 0; $x -lt 16; $x++) {
  for ($y = 0; $y -lt 16; $y++) {
    $edge = ($x -eq 0 -or $y -eq 0 -or $x -eq 15 -or $y -eq 15)
    $d = $rnd.Next(-18, 18)
    if ($edge) { $c = [System.Drawing.Color]::FromArgb(255, 120, 10, 30) }
    else { $c = [System.Drawing.Color]::FromArgb(255, 179 + $d, 18 + [math]::Abs($d), 47 + [math]::Abs($d)) }
    $bmp.SetPixel($x, $y, $c)
  }
}
$bmp.Save((Resolve-Path (Split-Path $out)).Path + '\ruby_block.png', [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
