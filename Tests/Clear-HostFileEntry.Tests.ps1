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
        $null = Get-HostFile
    }
    Context "Tests - Clear-HostFileEntry" {
        It "Test - Clear-HostFileEntry - Clears All HostFile Entries" {
            # leaves on the remaining 22 header lines
            Clear-HostFileEntry
            Get-HostFile | Measure-Object | Select-Object -ExpandProperty Count | Should -Be 22
        }
    }
    AfterAll {
        Clear-HostFileObject
        Clear-HostFilePath
    }
}