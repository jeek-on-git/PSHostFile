
Describe "HostFile Tests" {

    BeforeAll {

        Import-Module "..\HostFile.psd1" -Force

        Clear-HostFileObject
        Clear-HostFilePath

        $file = "$PSScriptRoot\hosts"
        $null = New-HostFileObject -hostFilePath $file
        $null = Get-HostFile

    } # beforeAll

    Context "Tests - Clear-HostFileEntry" {

        It "Test - Clear-HostFileEntry - Clears All HostFile Entries" {
            # leaves on the remaining 22 header lines
            Clear-HostFileEntry
            Get-HostFile | Measure-Object -Property LineNumber | Select-Object -ExpandProperty Count | Should -Be 22
        }

    }

    AfterAll {
        Clear-HostFileObject
        Clear-HostFilePath
    }

}