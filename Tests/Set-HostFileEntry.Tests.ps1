Describe "Set-HostFileEntry Tests" {

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

    } # beforeAll

    Context "Tests - Set-HostFileEntry" {

        It "Test - modifying 'IPAddress'" {
            Get-HostFileEntry 26 | Set-HostFileEntry -ipAddress '10.10.10.10'
            Get-HostFileEntry 26 | Select-Object -ExpandProperty IPAddress | Should -be '10.10.10.10'
        }

        It "Test - modifying 'Commented'" {
            Get-HostFileEntry 26 | Set-HostFileEntry -commented
            Get-HostFileEntry 26 | Select-Object -ExpandProperty IPAddress | Should -be '# 10.10.10.10'
        }

        It "Test - modifying 'HostName'" {
            Get-HostFileEntry 26 | Set-HostFileEntry -hostname 'PesterTest'
            Get-HostFileEntry 26 | Select-Object -ExpandProperty HostName | Should -be 'PesterTest'
        }

        It "Test - Testing for Spaces - <_>" -foreach @(
            '#Pester Comment'
            '# Pester Comment '
            '#  Pester Comment  '
            '#   Pester Comment   '
            '#    Pester Comment    '
            ' # Pester Comment'
            ' # Pester Comment '
            ' #  Pester Comment  '
            ' #   Pester Comment   '
            ' #    Pester Comment    '
            '  # Pester Comment'
            '  # Pester Comment '
            '  #  Pester Comment  '
            '  #   Pester Comment   '
            '  #    Pester Comment    '
        ) {
            Get-HostFileEntry 26 | Set-HostFileEntry -comment $_
            Get-HostFileEntry 26 | Select-Object -ExpandProperty Comment | Should -be '# Pester Comment'
        }

        It "Test - Testing for Spaces - <_>" -foreach @(
            '1.1.1.1'
            ' 1.1.1.1 '
            '  1.1.1.1  '
            '   1.1.1.1   '
            '    1.1.1.1    '
        ) {
            Get-HostFileEntry 26 | Set-HostFileEntry -ipAddress $_
            Get-HostFileEntry 26 | Select-Object -ExpandProperty IPAddress | Should -be '1.1.1.1'
        }

        It "Test - Testing for Spaces - <_>" -foreach @(
            'hostname'
            ' hostname '
            '  hostname  '
            '   hostname   '
            '    hostname   '
        ) {
            Get-HostFileEntry 26 | Set-HostFileEntry -hostname $_
            Get-HostFileEntry 26 | Select-Object -ExpandProperty HostName | Should -be 'hostname'
        }

        It "Test - Testing for Spaces - <_>" -foreach @(
            'hostname.local'
            ' hostname.local '
            '  hostname.local  '
            '   hostname.local   '
            '    hostname.local    '
        ) {
            Get-HostFileEntry 26 | Set-HostFileEntry -hostname $_
            Get-HostFileEntry 26 | Select-Object -ExpandProperty HostName | Should -be 'hostname.local'
        }

        It "Test - Testing for Spaces - <_>" -foreach @(
            'www.test.com'
            ' www.test.com '
            '  www.test.com  '
            '   www.test.com   '
            '    www.test.com    '
        ) {
            Get-HostFileEntry 26 | Set-HostFileEntry -hostname $_
            Get-HostFileEntry 26 | Select-Object -ExpandProperty HostName | Should -be 'www.test.com'
        }

    }

    AfterAll {
        Clear-HostFileObject
        Clear-HostFilePath
    }

}

<#

#>