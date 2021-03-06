
Describe "New-HostFileEntry" {

    BeforeAll {

        Import-Module "..\PSHostFile.psd1" -Force

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

        It "Test - IPAddress removing space from <_> " -foreach @(
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

        It "Test - HostName removing space from <_> " -foreach @(
            'hostname'
            ' hostname '
            '  hostname  '
            '   hostname   '
            '    hostname   '
        ) {
            New-HostFileEntry -ipAddress '1.1.1.1' -hostname $_ | Select-Object -ExpandProperty HostName | Should -be 'hostname'
        }

        It "Test - HostName removing space from <_> " -foreach @(
            'hostname.local'
            ' hostname.local '
            '  hostname.local  '
            '   hostname.local   '
            '    hostname.local   '
        ) {
            New-HostFileEntry -ipAddress '1.1.1.1' -hostname $_ | Select-Object -ExpandProperty HostName | Should -be 'hostname.local'
        }
        It "Test - HostName removing space from <_> " -foreach @(
            'www.test.com'
            ' www.test.com '
            '  www.test.com  '
            '   www.test.com   '
            '    www.test.com   '
        ) {
            New-HostFileEntry -ipAddress '1.1.1.1' -hostname $_ | Select-Object -ExpandProperty HostName | Should -be 'www.test.com'
        }

        It "Test - Commented - Hash is added to IPAddress - <_> " -foreach @(
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