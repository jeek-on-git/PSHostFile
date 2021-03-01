
Describe "HostFile Tests" {

    BeforeAll {

        Import-Module "..\PSHostFile.psd1" -Force

        Clear-HostFileObject
        Clear-HostFilePath

        $file = "$PSScriptRoot\hosts"
        # $null = New-HostFileObject -hostFilePath $file
        # $null = Get-HostFile

    } # beforeAll

    Context "Tests - HostFileObject" {

        It "Test - HostFile specified is used" {
            New-HostFilePath -hostFilePath $file
            Get-HostFilePath | Should -Be $file
        }
        It "Test - New-HostFileObject creates HostFileObject" {
            New-HostFileObject -hostFilePath $file
            Test-HostFileVariable -hostFileObject | Should -Be $true
        }
        It "Test - 'HostFileObject' variable is of specific Type - [HostFile]" {
            Get-HostFile | get-member | Select-Object -ExpandProperty TypeName -Unique | Should -Be 'HostFile'
        }
        It "Test - Contains 'Header'" -foreach $(Get-HostFile | Select-Object -First 22) {
            $_.EntryType | Should -Be 'Header'
        }
        It "Test - First 22 Entries Should Not Match EntryType" -foreach $(Get-HostFile | Select-Object -First 22 | Get-HostFileEntryType -diag) {
            $_.Entry -Match $_.EntryType | Should -Be $false
        }
        It "Test - Entry after line 22 Should Match EntryType" -foreach $(Get-HostFile | Select-Object -Skip 22 | Get-HostFileEntryType -diag) {
            $_.Entry -Match $_.EntryType | Should -Be $true
        }

    } # context

    AfterAll {
        Clear-HostFileObject
        Clear-HostFilePath
    }

}