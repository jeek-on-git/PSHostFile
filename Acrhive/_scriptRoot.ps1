
# $PSScriptRoot
# Set-Location ..
# Get-Location | Select-Object -ExpandProperty path

#$module = Join-Path $loc.Directory.FullName "HostFile.psd1"
#Import-Module $module -Force -PassThru

[System.IO.FileInfo]$loc = $(Get-Location).ToString()
$parent = $loc.Directory.FullName

$module = Join-Path $parent "HostFile.psd1"
# $module
# Test-Path Module

$filePath = "$parent\Files\hosts"
# Test-Path $filePath
# New-HostFilePath $filePath
# Get-HostFile

[PSCustomObject]@{
    ParentPath     = $parent
    ParentExists   = $(Test-Path $parent)
    ModulePath     = $module
    ModuleExists   = $(Test-Path $module)
    HostFilePath   = $filePath
    HostFileExists = $(Test-Path $filePath)
}


# Import-Module $module -Force -PassThru

<#
$private =  Join-Path $loc.Directory.FullName 'Private'
$private

$functions = @(
    'Get-HostFileEntryType.ps1'
    'Get-HostFileLineType.ps1'
)

$functions | foreach {
    $p = $(Join-Path $private $_)
    . $p
}



[System.IO.FileInfo]$loc = $(Get-Location).ToString()
$module = Join-Path $loc.Directory.FullName "HostFile.psd1"
Import-Module $module -Force -PassThru

$private =  Join-Path $loc.Directory.FullName 'Private'

Import-Module $PSScriptRoot"D:\Garry\Repos\Modules\HostFile\HostFile.psd1" -force
. D:\Garry\Repos\Modules\HostFile\Private\Get-HostFileEntryType.ps1
. D:\Garry\Repos\Modules\HostFile\Private\Get-HostFileLineType.ps1

. $PSScriptRoot\
# $psd = Join-Path $PSScriptRoot "HostFile.psd1"
# Import-Module $psd -Force
#$file = 'C:\Windows\System32\Drivers\etc\hosts'
# New-HostFilePath -hostFilePath "$env:PSModulePath\HostFile\Files\Hosts"

[System.IO.FileInfo]$loc = $(Get-Location).ToString()
$private =  Join-Path $loc.Directory.FullName 'Private'

$functions = @(
    'Get-HostFileEntryType.ps1'
    'Get-HostFileLineType.ps1'
    )

$functions | foreach {
    $p = $(Join-Path $private $_)
    . $p
}
#>

