
Describe "HostFile Tests" {

    BeforeAll {

        # Import-Module "..\PSHostFile.psd1" -Force
        $root = ([System.IO.FileInfo]$PSScriptRoot).Directory.FullName
        $path = Join-Path $root "PSHostFile.psd1"
        Import-Module $path -force

        Clear-HostFileObject
        Clear-HostFilePath

        $file = "$PSScriptRoot\hosts"
        $null = New-HostFileObject -hostFilePath $file
        # $null = Get-HostFile
        $count = Get-HostFile | Measure-Object | Select-Object -ExpandProperty Count
        $number = Get-Random -Minimum 22 -Maximum $count

    } # beforeAll

    Context "Tests - Remove-HostFileEntry" {

        It "Test - Remove-HostFileEntry <number> via Pipeline" {
            $entry = Get-HostFileEntry $number
            $null = $entry | Remove-HostFileEntry
            $(Get-HostFile) -contains $entry | Should -Be $false
        }
        It "Test - New-HostFileEntry <number> via Parameter" {
            $entry = Get-HostFileEntry $number
            $null = Remove-HostFileEntry -hostFileEntry $entry
            $(Get-HostFile) -contains $entry | Should -Be $false
        }

    }

    AfterAll {
        Clear-HostFileObject
        Clear-HostFilePath
    }

}