Add-Type -AssemblyName System.Drawing
$dir = Join-Path $PSScriptRoot "..\assets\themes"
Get-ChildItem $dir -File | Where-Object { $_.Extension -match '\.(png|jpg|jpeg|webp)$' } | ForEach-Object {
  $img = [System.Drawing.Image]::FromFile($_.FullName)
  Write-Host ("{0}`t{1}x{2}" -f $_.Name, $img.Width, $img.Height)
  $img.Dispose()
}
