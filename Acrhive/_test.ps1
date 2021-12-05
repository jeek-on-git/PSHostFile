
$root = ([System.IO.FileInfo]$PSScriptRoot).Directory.FullName
$path = Join-Path $root "PSHostFile.psd1"
$path
Import-Module $path
#"$root\PSHostFile.psd1"
#Import-Module "$root\PSHostFile.psd1"