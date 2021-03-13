
Describe "Get-HostsFileObject Tests" {

    BeforeAll {

        # Import-Module "..\PSHostFile.psd1" -Force
        $root = ([System.IO.FileInfo]$PSScriptRoot).Directory.FullName
        $path = Join-Path $root "PSHostFile.psd1"
        Import-Module $path -force

        Clear-HostFileObject
        Clear-HostFilePath

        $file = "$PSScriptRoot\hosts"
        New-HostFilePath $file

    } # beforeAll

    Context "Tests - HostsFileObject" {

        It "Test - Specified HostsFile is used" {
            # New-HostFilePath -hostFilePath $file
            Get-HostFilePath | Should -Be $file
        }

        It "Test - New-HostsFileObject creates HostsFileObject" {
            New-HostFileObject -hostFilePath $file
            Test-HostFileVariable -hostFileObject | Should -Be $true
        }

        It "Test - 'HostsFileObject' Type is [HostFile]" {
            Get-HostFile | get-member | Select-Object -ExpandProperty TypeName -Unique | Should -Be 'HostFile'
        }

        It "Test - 'HostsFileObject' Contains 'Header'" -foreach $(Get-HostFile | Select-Object -First 22) {
            $_.EntryType | Should -Be 'Header'
        }

        It "Test - First 22 Entries Should Not Match EntryType" -foreach $(Get-HostFile | Select-Object -First 22 | Get-HostFileEntryType -diag) {
            $_.Entry -Match $_.EntryType | Should -Be $false
        }

        It "Test - Entry after line 22 Should Match EntryType" -foreach $(Get-HostFile | Select-Object -Skip 22 | Get-HostFileEntryType -diag) {
            $_.Entry -Match $_.EntryType | Should -Be $true
        }

        It "Test - Line 26 EntryType Should Be HostEntry" {
            Get-HostFileEntry -lineNumber 26 | Select-Object -ExpandProperty EntryType | Should -Be 'HostEntry'
        }

        It "Test - Line 26 IPAddress Should Be 1.1.1.1" {
            Get-HostFileEntry -lineNumber 26 | Select-Object -ExpandProperty IPAddress | Should -Be '1.1.1.1'
        }

        It "Test - Line 26 HostName Should Be Pester" {
            Get-HostFileEntry -lineNumber 26 | Select-Object -ExpandProperty HostName | Should -Be 'Pester'
        }

        It "Test - Line 26 Comment Should Be # Pester" {
            Get-HostFileEntry -lineNumber 26 | Select-Object -ExpandProperty Comment | Should -Be '# Pester'
        }

        It "Test - Line 27 EntryType Should Be Commented" {
            Get-HostFileEntry -lineNumber 27 | Select-Object -ExpandProperty EntryType | Should -Be 'Commented'
        }

        It "Test - Line 27 IPAddress Should Be 1.1.1.1" {
            Get-HostFileEntry -lineNumber 27 | Select-Object -ExpandProperty IPAddress | Should -Be '# 1.1.1.1'
        }

        It "Test - Line 27 HostName Should Be Pester" {
            Get-HostFileEntry -lineNumber 27 | Select-Object -ExpandProperty HostName | Should -Be 'Pester'
        }

        It "Test - Line 27 Comment Should Be # Pester" {
            Get-HostFileEntry -lineNumber 27 | Select-Object -ExpandProperty Comment | Should -Be '# Pester'
        }

        It "Test - Line 28 EntryType Should Be Comment" {
            Get-HostFileEntry -lineNumber 28 | Select-Object -ExpandProperty EntryType | Should -Be 'Comment'
        }

        It "Test - Line 28 EntryType Should Be Comment" {
            Get-HostFileEntry -lineNumber 28 | Select-Object -ExpandProperty Comment | Should -Be '# Pester'
        }

    } # context

    AfterAll {
        Clear-HostFileObject
        Clear-HostFilePath
    }

}