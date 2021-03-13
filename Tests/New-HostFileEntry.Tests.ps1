
Describe "New-HostFileEntry" {

    BeforeAll {

        # Import-Module "..\PSHostFile.psd1" -Force
        $root = ([System.IO.FileInfo]$PSScriptRoot).Directory.FullName
        $path = Join-Path $root "PSHostFile.psd1"
        Import-Module $path -force

        $file = "$PSScriptRoot\hosts"
        New-HostFilePath $file
        Get-HostFile

    } # beforeAll

    Context "Tests - New-HostFileEntry" {

        It "Test - New-HostFileEntry 'HostEntry'" {
            $entry = New-HostFileEntry -ipAddress 10.10.10.10 -hostname server
            $entry | Get-HostFileEntryType | Should -Be 'HostEntry'
        }
        It "Test - New-HostFileEntry 'Commented'" {
            $entry = New-HostFileEntry -ipAddress 10.10.10.10 -hostname server -commented
            $entry | Get-HostFileEntryType | Should -Be 'Commented'
        }
        It "Test - New-HostFileEntry 'Blank'" {
            $entry = New-HostFileEntry -blank
            $entry | Get-HostFileEntryType | Should -Be 'Blank'
        }

        It "Test - Testing 'IPAddress' for spaces - <_>" -foreach @(
            '1.1.1.1'
            ' 1.1.1.1 '
            '  1.1.1.1  '
            '   1.1.1.1   '
            '    1.1.1.1    '
            '#1.1.1.1'
            '# 1.1.1.1 '
            '#  1.1.1.1  '
            '#   1.1.1.1   '
            '#    1.1.1.1   '
        ) {
            New-HostFileEntry -ipAddress $_ -hostname 'Pester' | Select-Object -ExpandProperty IPAddress | Should -be '1.1.1.1'
        }

        It "Test - Testing 'Hostname' for spaces - <_> " -foreach @(
            'hostname'
            ' hostname '
            '  hostname  '
            '   hostname   '
            '    hostname   '
        ) {
            New-HostFileEntry -ipAddress '1.1.1.1' -hostname $_ | Select-Object -ExpandProperty HostName | Should -be 'hostname'
        }

        It "Test - Testing 'Hostname' for spaces -  <_> " -foreach @(
            'hostname.local'
            ' hostname.local '
            '  hostname.local  '
            '   hostname.local   '
            '    hostname.local   '
        ) {
            New-HostFileEntry -ipAddress '1.1.1.1' -hostname $_ | Select-Object -ExpandProperty HostName | Should -be 'hostname.local'
        }
        It "Test - Testing 'Hostname' for spaces - <_> " -foreach @(
            'www.test.com'
            ' www.test.com '
            '  www.test.com  '
            '   www.test.com   '
            '    www.test.com   '
        ) {
            New-HostFileEntry -ipAddress '1.1.1.1' -hostname $_ | Select-Object -ExpandProperty HostName | Should -be 'www.test.com'
        }

        It "Test - Testing 'Commented' for spaces - <_> " -foreach @(
            '1.1.1.1'
            ' 1.1.1.1 '
            '  1.1.1.1  '
            '   1.1.1.1   '
            '    1.1.1.1    '
            '#1.1.1.1'
            '# 1.1.1.1 '
            '#  1.1.1.1  '
            '#   1.1.1.1   '
            '#    1.1.1.1   '
        ) {
            New-HostFileEntry -ipAddress $_ -hostname 'Pester' -commented | Select-Object -ExpandProperty IPAddress | Should -be '# 1.1.1.1'
        }

    }

}
# New-HostFileEntry -ipAddress ' #  1.1.1.1' -hostname 'Pester' -comment      '#       test'