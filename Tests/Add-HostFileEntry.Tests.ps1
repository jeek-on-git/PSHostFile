
Describe "Add-HostFileEntry" {

    BeforeAll {

        # Import-Module ".\PSHostFile.psd1" -Force
        $root = ([System.IO.FileInfo]$PSScriptRoot).Directory.FullName
        $path = Join-Path $root "PSHostFile.psd1"
        Import-Module $path -force

        $file = "$PSScriptRoot\hosts"
        New-HostFilePath $file
        Get-HostFile

        $count = Get-HostFile | Select-Object -ExpandProperty LineNumber -Last 1
        $entry = New-HostFileEntry -ipAddress 1.1.1.1 -hostname 'pester'

    } # beforeAll

    Context "Tests - New-HostFileEntry" {


        It "Test - Add-HostFileEntry - <count> + 1" {
            $entry.LineNumber | should -BeGreaterThan $count
        }

        It "Test - Add-HostFileEntry - <count> + 1" {
            $entry.IPAddress | should -Be '1.1.1.1'
        }

        It "Test - Add-HostFileEntry - <count> + 1" {
            $entry.HostName | should -Be 'Pester'
        }
    }
    Context "test" {

        BeforeAll {
            Add-HostFileEntry $entry
        }

        It "Test - Add-HostFileEntry - Entry equals" {
            Get-HostFile | Select-Object -Last 1 | Should -be $entry
        }

        It "Test - Add-HostFileEntry - Entry equals" {
            Get-HostFile | Select-Object -Last 1 -ExpandProperty IPAddress | Should -be $entry.IPAddress
        }

        It "Test - Add-HostFileEntry - Entry equals" {
            Get-HostFile | Select-Object -Last 1 -ExpandProperty HostName | Should -be $entry.HostName
        }

    }

}