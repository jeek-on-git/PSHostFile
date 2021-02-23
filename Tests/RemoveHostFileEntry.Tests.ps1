
Describe "HostFile Tests" {

    BeforeAll {

        Import-Module "..\HostFile.psd1" -Force

        Clear-HostFileObject
        Clear-HostFilePath

        $file = "$PSScriptRoot\hosts"
        $null = New-HostFileObject -hostFilePath $file
        $null = Get-HostFile

    } # beforeAll

    Context "Tests - Remove-HostFileEntry" {
        It "Test - Remove-HostFileEntry via Pipeline" {
            $entry = Get-HostFileEntry 26
            $null = $entry | Remove-HostFileEntry
            $(Get-HostFile) -contains $entry | Should -Be $false
        }
        It "Test - New-HostFileEntry via Parameter" {
            $entry = Get-HostFileEntry 26
            $null = Remove-HostFileEntry -hostFileEntry $entry
            $(Get-HostFile) -contains $entry | Should -Be $false
        }
    }

    AfterAll {
        Clear-HostFileObject
        Clear-HostFilePath
    }

}