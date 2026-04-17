Add-Type -AssemblyName System.Drawing

function Write-ThemePng([int]$w, [int]$h, [string]$fileName) {
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.Clear([System.Drawing.Color]::FromArgb(15, 23, 42))
  $rect = New-Object System.Drawing.Rectangle 0, 0, $w, $h
  $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, `
    ([System.Drawing.Color]::FromArgb(30, 58, 95)), `
    ([System.Drawing.Color]::FromArgb(15, 23, 42)), 45
  $g.FillRectangle($brush, 0, 0, $w, $h)
  $brush.Dispose()
  $g.Dispose()
  $dir = Join-Path $PSScriptRoot "..\assets\themes"
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  $path = Join-Path $dir $fileName
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Host "Wrote $path"
}

Write-ThemePng 1080 1920 "hestora_story_default.png"
Write-ThemePng 1080 1080 "hestora_square_default.png"
