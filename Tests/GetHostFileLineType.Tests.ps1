
Describe "HostFile Tests" {

    BeforeAll {

        Import-Module "..\PSHostFile.psd1" -Force

        Clear-HostFileObject
        Clear-HostFilePath

    } # beforeAll

    Context "Tests - Get-HostFileLineType" {

        It "Test - Get-HostFileLineType - Blanks" -foreach @(
            @{ Blank = ''}
            @{ Blank = ' '}
            @{ Blank = '  '}
            @{ Blank = '   '}
            @{ Blank = '    '}
            @{ Blank = ""}
            @{ Blank = " "}
            @{ Blank = "  "}
            @{ Blank = "   "}
            @{ Blank = "    "}) {
            Get-HostFileLineType $blank | Should -Be 'Blank'
        }
        It "Test - Get-HostFileLineType - HostEntry" -foreach @(
            @{ HostEntry = '0.0.0.0'}
            @{ HostEntry = '10.10.10.10'}
            @{ HostEntry = '192.168.0.0'}
            @{ HostEntry = '172.16.0.0'}
            @{ HostEntry = '0.0.0.0    ServerName'}
            @{ HostEntry = '10.10.10.10    ServerName'}
            @{ HostEntry = '192.168.0.0    ServerName'}
            @{ HostEntry = '172.16.0.0    ServerName'}
            @{ HostEntry = '0.0.0.0    ServerName    # Comment'}
            @{ HostEntry = '10.10.10.10    ServerName    # Comment'}
            @{ HostEntry = '192.168.0.0    ServerName    # Comment'}
            @{ HostEntry = '172.16.0.0    ServerName    # Comment'}) {
            Get-HostFileLineType $hostEntry | Should -Be 'HostEntry'
        }

        It "Test - Get-HostFileLineType - Commented" -ForEach @(
            @{ Commented = '# 127.0.0.1'}
            @{ Commented = '# 10.21.21.21   server.local'}
            @{ Commented = '# 10.21.21.21   server.local # comments'}) {
            Get-HostFileLineType $commented | Should -Be 'Commented'
        }

        It "Test - Get-HostFileLineType - Comment" -ForEach @(
            @{ comment = '#'}
            @{ comment = '# '}
            @{ comment = '#  '}
            @{ comment = '#   '}
            @{ comment = '# ::1'}
            @{ comment = '# text'}
            @{ comment = '# text text'}) {
            Get-HostFileLineType $comment | Should -Be 'Comment'
        }

    } # context

} # describe